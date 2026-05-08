import SwiftUI

struct PortRow: View {
    let entry: PortEntry
    let isKilling: Bool
    let onKill: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(String(entry.port))
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                Text(entry.displayAddress)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 72, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.fullCommand.isEmpty ? entry.command : entry.fullCommand)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
                    .truncationMode(.middle)
                Text("\(entry.command) · pid \(entry.pid)")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            Button(action: onKill) {
                Group {
                    if isKilling {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Image(systemName: "xmark")
                            .font(.system(size: 11, weight: .bold))
                    }
                }
                .frame(width: 22, height: 22)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .foregroundStyle(.red)
            .background(
                Circle().fill(.red.opacity(isHovered ? 0.18 : 0.10))
            )
            .disabled(isKilling)
            .help("Terminate (SIGTERM → SIGKILL)")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(isHovered ? Color.primary.opacity(0.06) : .clear)
        )
        .contentShape(Rectangle())
        .onHover { isHovered = $0 }
    }
}
