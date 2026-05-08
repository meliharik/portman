import Foundation

struct PortEntry: Identifiable, Hashable {
    let pid: Int32
    let port: Int
    let address: String
    let command: String
    let fullCommand: String

    var id: String { "\(pid)-\(address)-\(port)" }

    var displayAddress: String {
        switch address {
        case "*", "0.0.0.0", "[::]": return "all"
        case "127.0.0.1", "[::1]": return "localhost"
        default: return address
        }
    }
}
