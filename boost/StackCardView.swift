import SwiftUI

struct StackCardView: View {
    @Environment(AppState.self) var state
    var logAction: () -> Void

    var body: some View {
        let stack = state.currentStack
        let accent = Theme.accent(for: stack.accentColor)

        VStack(alignment: .leading, spacing: 0) {
            // Card header
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(stack.emoji)
                        .font(.system(size: 28))

                    Text(stack.name)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)

                    Spacer()
                }

                Text(stack.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Theme.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)

            // Accent line
            Rectangle()
                .fill(accent.opacity(0.4))
                .frame(height: 1)
                .padding(.horizontal, 20)

            // Content: either supplement list or behavioural nudge
            if stack.isBehavioural {
                behaviouralNudge(stack: stack)
            } else {
                supplementList(stack: stack, accent: accent)
            }

            // Stack notes
            if let notes = stack.notes, !stack.isBehavioural {
                Text(notes)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Theme.tertiary)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
            }

            // Took this button
            if !stack.isBehavioural {
                tookThisButton(accent: accent)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    @ViewBuilder
    private func supplementList(stack: Stack, accent: Color) -> some View {
        VStack(spacing: 0) {
            // Required supplements
            ForEach(Array(stack.supplements.enumerated()), id: \.offset) { idx, id in
                if let supp = state.supplement(for: id) {
                    SupplementRow(supplement: supp, accent: accent)
                    if idx < stack.supplements.count - 1 || (stack.optional?.isEmpty == false) {
                        Divider()
                            .background(Theme.separator)
                            .padding(.leading, 20)
                    }
                }
            }

            // Optional supplements
            if let optionals = stack.optional, !optionals.isEmpty {
                ForEach(optionals, id: \.self) { id in
                    if let supp = state.supplement(for: id) {
                        OptionalRow(id: id, supplement: supp, accent: accent)
                        Divider()
                            .background(Theme.separator)
                            .padding(.leading, 20)
                    }
                }
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private func behaviouralNudge(stack: Stack) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(stack.notes ?? "No supplements. Just a nudge.")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white.opacity(0.85))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                logAction()
            } label: {
                HStack {
                    Image(systemName: "arrow.up.right")
                    Text("yeah, stepping away")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(20)
    }

    @ViewBuilder
    private func tookThisButton(accent: Color) -> some View {
        Button {
            logAction()
        } label: {
            Text("boosted!")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(accent, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(.top, 8)
    }
}

struct SupplementRow: View {
    let supplement: Supplement
    let accent: Color

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Circle()
                .fill(accent.opacity(0.6))
                .frame(width: 6, height: 6)

            VStack(alignment: .leading, spacing: 2) {
                Text(supplement.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)

                Text(supplement.purpose)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Theme.secondary)
            }

            Spacer()

            Text(supplement.dose)
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundStyle(Theme.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

struct OptionalRow: View {
    @Environment(AppState.self) var state
    let id: String
    let supplement: Supplement
    let accent: Color

    var isEnabled: Bool { state.enabledOptionals.contains(id) }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button {
                withAnimation(.spring(duration: 0.2)) {
                    state.toggleOptional(id)
                }
            } label: {
                Image(systemName: isEnabled ? "checkmark.circle.fill" : "plus.circle")
                    .font(.system(size: 18))
                    .foregroundStyle(isEnabled ? accent : Theme.tertiary)
                    .animation(.spring(duration: 0.2), value: isEnabled)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(supplement.name)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(isEnabled ? .white : Theme.secondary)

                    Text("optional")
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .tracking(1)
                        .foregroundStyle(Theme.tertiary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Theme.cardElevated, in: Capsule())
                }

                Text(supplement.purpose)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Theme.tertiary)
            }

            Spacer()

            Text(supplement.dose)
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundStyle(Theme.tertiary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}
