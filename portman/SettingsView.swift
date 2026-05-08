import SwiftUI

struct SettingsView: View {
    @State private var autostart = AutostartManager.shared
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Form {
            Section {
                Toggle(isOn: Binding(
                    get: { autostart.isEnabled },
                    set: { autostart.setEnabled($0) }
                )) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Launch at login")
                        Text("Open portman automatically when you log in.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .toggleStyle(.switch)
            }

            Section {
                Button {
                    openWindow(id: "welcome")
                } label: {
                    HStack {
                        Text("Show welcome screen")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }

            Section {
                LabeledContent("Version", value: appVersion)
                LabeledContent("Build", value: buildNumber)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .onAppear { autostart.refresh() }
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}
