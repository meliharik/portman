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
                Divider()
                SettingsView()
            } else {
                header
                Divider()
                searchField
                Divider()
                content
                Divider()
                footer
            }
        }
        .frame(width: 380, height: 480)
        .task {
            await store.refresh()
            store.startAutoRefresh()
        }
        .onDisappear { store.stopAutoRefresh() }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 6) {
            Text("Listening Ports")
                .font(.headline)
            Spacer()
            iconButton("arrow.clockwise", help: "Refresh") {
                Task { await store.refresh() }
            }
            iconButton("gearshape", help: "Settings") {
                withAnimation(.easeInOut(duration: 0.18)) { showSettings = true }
            }
            Menu {
                Button("Quit portman") { NSApplication.shared.terminate(nil) }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
            .fixedSize()
        }
        .padding(.horizontal, 14)
        .padding(.top, 12)
        .padding(.bottom, 10)
    }

    private var settingsHeader: some View {
        HStack(spacing: 6) {
            Button {
                withAnimation(.easeInOut(duration: 0.18)) { showSettings = false }
            } label: {
                HStack(spacing: 3) {
                    Image(systemName: "chevron.left")
                    Text("Ports")
                }
                .font(.body)
                .foregroundStyle(Color.accentColor)
            }
            .buttonStyle(.plain)
            Spacer()
            Text("Settings")
                .font(.headline)
            Spacer()
            // Spacer to balance the back button visually
            Color.clear.frame(width: 50, height: 1)
        }
        .padding(.horizontal, 14)
        .padding(.top, 12)
        .padding(.bottom, 10)
    }

    private func iconButton(_ name: String, help: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: name)
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(width: 22, height: 22)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .help(help)
    }

    // MARK: - Search

    private var searchField: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .font(.callout)
                .foregroundStyle(.secondary)
            TextField("Search port or command", text: $search)
                .textFieldStyle(.plain)
                .font(.body)
            if !search.isEmpty {
                Button {
                    search = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .symbolRenderingMode(.hierarchical)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 7, style: .continuous))
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    // MARK: - Content

    private var content: some View {
        Group {
            if filtered.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 1) {
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
            Image(systemName: emptyIcon)
                .font(.system(size: 32, weight: .light))
                .foregroundStyle(.tertiary)
                .symbolRenderingMode(.hierarchical)
            Text(emptyText)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyIcon: String {
        if !search.isEmpty { return "magnifyingglass" }
        if store.isLoading && store.entries.isEmpty { return "arrow.triangle.2.circlepath" }
        return "checkmark.seal"
    }

    private var emptyText: String {
        if !search.isEmpty { return "No matches for \u{201C}\(search)\u{201D}" }
        if store.isLoading && store.entries.isEmpty { return "Scanning\u{2026}" }
        return "No listening ports"
    }

    // MARK: - Footer

    private var footer: some View {
        HStack {
            Text("\(store.entries.count) \(store.entries.count == 1 ? "port" : "ports")")
                .font(.caption)
                .foregroundStyle(.secondary)
                .monospacedDigit()
            Spacer()
            HStack(spacing: 4) {
                Circle()
                    .fill(.green)
                    .frame(width: 6, height: 6)
                Text("Live")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }
}
