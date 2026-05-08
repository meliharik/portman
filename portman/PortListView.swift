import SwiftUI

struct PortListView: View {
    @State private var store = PortStore()
    @State private var search: String = ""
    @State private var showSettings: Bool = false

    private var filtered: [PortEntry] {
        guard !search.isEmpty else { return store.entries }
        let needle = search.lowercased()
        return store.entries.filter { entry in
            String(entry.port).contains(needle)
                || entry.command.lowercased().contains(needle)
                || entry.fullCommand.lowercased().contains(needle)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            if showSettings {
                settingsHeader
                Divider().opacity(0.3)
                SettingsView()
            } else {
                header
                Divider().opacity(0.3)
                content
                Divider().opacity(0.3)
                footer
            }
        }
        .frame(width: 380, height: 460)
        .task {
            await store.refresh()
            store.startAutoRefresh()
        }
        .onDisappear { store.stopAutoRefresh() }
    }

    private var header: some View {
        HStack(spacing: 8) {
            Image(systemName: "point.3.connected.trianglepath.dotted")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
            Text("portman")
                .font(.system(size: 13, weight: .semibold))
            Spacer()
            iconButton(systemName: "arrow.clockwise", help: "Refresh") {
                Task { await store.refresh() }
            }
            iconButton(systemName: "gearshape", help: "Settings") {
                showSettings = true
            }
            iconButton(systemName: "power", help: "Quit portman") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private var settingsHeader: some View {
        HStack(spacing: 8) {
            iconButton(systemName: "chevron.left", help: "Back") {
                showSettings = false
            }
            Text("Settings")
                .font(.system(size: 13, weight: .semibold))
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private func iconButton(systemName: String, help: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 11, weight: .semibold))
                .frame(width: 22, height: 22)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.secondary)
        .help(help)
    }

    private var content: some View {
        Group {
            if filtered.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 2) {
                        ForEach(filtered) { entry in
                            PortRow(
                                entry: entry,
                                isKilling: store.killingPIDs.contains(entry.pid),
                                onKill: { Task { await store.kill(pid: entry.pid) } }
                            )
                        }
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 6)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: store.isLoading ? "ellipsis" : "checkmark.seal")
                .font(.system(size: 28, weight: .light))
                .foregroundStyle(.secondary)
            Text(emptyText)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyText: String {
        if !search.isEmpty { return "No matches for \u{201C}\(search)\u{201D}" }
        if store.isLoading && store.entries.isEmpty { return "Scanning\u{2026}" }
        return "No listening ports"
    }

    private var footer: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
            TextField("Search port or command", text: $search)
                .textFieldStyle(.plain)
                .font(.system(size: 12))
            if !search.isEmpty {
                Button {
                    search = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            Spacer()
            Text("\(store.entries.count) ports")
                .font(.system(size: 11))
                .foregroundStyle(.tertiary)
                .monospacedDigit()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}
