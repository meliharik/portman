import AppKit
import SwiftUI

struct PortRow: View {
    let entry: PortEntry
    let isKilling: Bool
    let onKill: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 12) {
            Text(String(entry.port))
                .font(.system(.title3, design: .monospaced).weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(Color.accentColor)
                .frame(width: 64, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(primaryLabel)
                    .font(.body)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Text(secondaryLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            Button(action: onKill) {
                if isKilling {
                    ProgressView().controlSize(.small)
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(isHovered ? Color.red : Color.secondary)
                        .symbolRenderingMode(.hierarchical)
                }
            }
            .buttonStyle(.plain)
            .disabled(isKilling)
            .help("Quit process (SIGTERM, then SIGKILL if needed)")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(isHovered ? Color.primary.opacity(0.06) : .clear)
        }
        .contentShape(Rectangle())
        .onHover { isHovered = $0 }
        .contextMenu {
            Button("Copy Port Number") { copy(String(entry.port)) }
            Button("Copy PID") { copy(String(entry.pid)) }
            Button("Copy Command") { copy(entry.fullCommand.isEmpty ? entry.command : entry.fullCommand) }
            Divider()
            Button("Quit Process", role: .destructive, action: onKill)
        }
    }

    private var primaryLabel: String {
        entry.fullCommand.isEmpty ? entry.command : entry.fullCommand
    }

    private var secondaryLabel: String {
        var parts = [entry.command, "PID \(entry.pid)"]
        if entry.displayAddress != "all" {
            parts.append(entry.displayAddress)
        }
        return parts.joined(separator: "  \u{2022}  ")
    }

    private func copy(_ string: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(string, forType: .string)
    }
}
