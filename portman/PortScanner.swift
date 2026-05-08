import Foundation

enum PortScanner {
    static func scan() async -> [PortEntry] {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                continuation.resume(returning: scanSync())
            }
        }
    }

    private static func scanSync() -> [PortEntry] {
        let user = NSUserName()
        guard let raw = runLsof(user: user) else { return [] }
        let entries = parse(raw)
        let pids = Set(entries.map { $0.pid })
        let commands = pids.reduce(into: [Int32: String]()) { acc, pid in
            acc[pid] = fullCommand(for: pid) ?? ""
        }
        return entries.map { e in
            PortEntry(
                pid: e.pid,
                port: e.port,
                address: e.address,
                command: e.command,
                fullCommand: commands[e.pid] ?? e.command
            )
        }
        .sorted { $0.port < $1.port }
    }

    private static func runLsof(user: String) -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/lsof")
        process.arguments = ["-a", "-iTCP", "-sTCP:LISTEN", "-nP", "-u", user, "-F", "pcn"]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = Pipe()
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return nil
        }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)
    }

    private static func fullCommand(for pid: Int32) -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/ps")
        process.arguments = ["-p", String(pid), "-o", "command="]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = Pipe()
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return nil
        }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func parse(_ text: String) -> [PortEntry] {
        var entries: [PortEntry] = []
        var currentPid: Int32 = 0
        var currentCommand: String = ""

        for line in text.split(separator: "\n") {
            guard let first = line.first else { continue }
            let value = String(line.dropFirst())
            switch first {
            case "p":
                currentPid = Int32(value) ?? 0
                currentCommand = ""
            case "c":
                currentCommand = value
            case "n":
                if let (addr, port) = splitAddressAndPort(value) {
                    entries.append(PortEntry(
                        pid: currentPid,
                        port: port,
                        address: addr,
                        command: currentCommand,
                        fullCommand: currentCommand
                    ))
                }
            default:
                continue
            }
        }
        return entries
    }

    private static func splitAddressAndPort(_ raw: String) -> (String, Int)? {
        // Strip "->" remote part if any (LISTEN entries shouldn't have one)
        let local = raw.split(separator: "-", maxSplits: 1).first.map(String.init) ?? raw
        guard let colon = local.lastIndex(of: ":") else { return nil }
        let addr = String(local[local.startIndex..<colon])
        let portStr = String(local[local.index(after: colon)...])
        guard let port = Int(portStr) else { return nil }
        return (addr, port)
    }
}
