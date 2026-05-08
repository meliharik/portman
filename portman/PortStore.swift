import Foundation
import Observation

@MainActor
@Observable
final class PortStore {
    var entries: [PortEntry] = []
    var isLoading: Bool = false
    var lastError: String?
    var killingPIDs: Set<Int32> = []

    private var refreshTask: Task<Void, Never>?

    func startAutoRefresh(interval: Duration = .seconds(2)) {
        refreshTask?.cancel()
        refreshTask = Task { [weak self] in
            while !Task.isCancelled {
                await self?.refresh()
                try? await Task.sleep(for: interval)
            }
        }
    }

    func stopAutoRefresh() {
        refreshTask?.cancel()
        refreshTask = nil
    }

    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        let scanned = await PortScanner.scan()
        entries = scanned
    }

    func kill(pid: Int32) async {
        killingPIDs.insert(pid)
        defer { killingPIDs.remove(pid) }
        let result = await ProcessKiller.terminate(pid: pid)
        if case .failure(let err) = result {
            lastError = err.localizedDescription
        }
        await refresh()
    }
}
