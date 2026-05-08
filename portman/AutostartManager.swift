import Foundation
import Observation
import ServiceManagement

@MainActor
@Observable
final class AutostartManager {
    static let shared = AutostartManager()

    private(set) var isEnabled: Bool = false

    init() {
        refresh()
    }

    func refresh() {
        isEnabled = SMAppService.mainApp.status == .enabled
    }

    func setEnabled(_ enabled: Bool) {
        do {
            if enabled {
                if SMAppService.mainApp.status != .enabled {
                    try SMAppService.mainApp.register()
                }
            } else {
                if SMAppService.mainApp.status == .enabled {
                    try SMAppService.mainApp.unregister()
                }
            }
        } catch {
            // Surface to caller via refresh; status will reflect actual state
        }
        refresh()
    }
}
