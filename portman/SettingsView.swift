import SwiftUI

struct SettingsView: View {
    @State private var autostart = AutostartManager.shared

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Settings")
                    .font(.system(size: 13, weight: .semibold))
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            .padding(.bottom, 8)

            Divider().opacity(0.3)

            VStack(spacing: 12) {
                Toggle(isOn: Binding(
                    get: { autostart.isEnabled },
                    set: { autostart.setEnabled($0) }
                )) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Launch at login")
                            .font(.system(size: 13))
                        Text("Open portman automatically when you log in")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                }
                .toggleStyle(.switch)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)

            Spacer()
        }
        .onAppear { autostart.refresh() }
    }
}
