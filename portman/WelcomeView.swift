import SwiftUI

struct WelcomeView: View {
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(width: 96, height: 96)
                    Image(systemName: "point.3.connected.trianglepath.dotted")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                        .symbolRenderingMode(.hierarchical)
                }

                VStack(spacing: 6) {
                    Text("Welcome to portman")
                        .font(.system(.largeTitle, design: .default).weight(.semibold))
                    Text("See and reclaim every port on your Mac.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.top, 44)
            .padding(.bottom, 28)

            VStack(alignment: .leading, spacing: 22) {
                FeatureRow(
                    icon: "dot.radiowaves.left.and.right",
                    title: "Live port scanning",
                    description: "Every TCP port your apps are listening on, refreshed every two seconds."
                )
                FeatureRow(
                    icon: "xmark.circle",
                    title: "One-click termination",
                    description: "Free a stuck port without opening Terminal. Sends SIGTERM, then SIGKILL if needed."
                )
                FeatureRow(
                    icon: "menubar.rectangle",
                    title: "Lives in your menu bar",
                    description: "Click the icon at the top of your screen whenever you need it. No Dock clutter."
                )
            }
            .padding(.horizontal, 56)

            Spacer(minLength: 24)

            Button {
                hasSeenWelcome = true
                dismiss()
            } label: {
                Text("Get Started")
                    .frame(maxWidth: .infinity, minHeight: 22)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .keyboardShortcut(.defaultAction)
            .padding(.horizontal, 56)
            .padding(.bottom, 32)
        }
        .frame(width: 520, height: 560)
        .background(.windowBackground)
    }
}

private struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 32, alignment: .center)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
