import Darwin
import Foundation

enum KillError: Error, LocalizedError {
    case noPermission
    case notFound
    case unknown(Int32)

    var errorDescription: String? {
        switch self {
        case .noPermission: return "No permission to terminate this process"
        case .notFound: return "Process no longer exists"
        case .unknown(let code): return "kill failed (errno \(code))"
        }
    }
}

enum ProcessKiller {
    static func terminate(pid: Int32) async -> Result<Void, KillError> {
        if let err = sendSignal(pid: pid, signal: SIGTERM), err != ESRCH {
            return .failure(mapError(err))
        }
        try? await Task.sleep(for: .milliseconds(1500))
        if isAlive(pid: pid) {
            if let err = sendSignal(pid: pid, signal: SIGKILL), err != ESRCH {
                return .failure(mapError(err))
            }
        }
        return .success(())
    }

    private static func sendSignal(pid: Int32, signal: Int32) -> Int32? {
        let result = kill(pid, signal)
        if result == 0 { return nil }
        return errno
    }

    private static func isAlive(pid: Int32) -> Bool {
        kill(pid, 0) == 0
    }

    private static func mapError(_ code: Int32) -> KillError {
        switch code {
        case EPERM: return .noPermission
        case ESRCH: return .notFound
        default: return .unknown(code)
        }
    }
}
