import SwiftUI

struct StackCardView: View {
    @Environment(AppState.self) var state
    var logAction: () -> Void

    var body: some View {
        let stack = state.currentStack
        let accent = Theme.accent(for: stack.accentColor)

        VStack(alignment: .leading, spacing: 0) {
            // Card header
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(stack.name)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)

                        Text(stack.description)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Theme.secondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    Text(stack.emoji)
                        .font(.system(size: 36))
                        .opacity(0.85)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 22)
            .padding(.bottom, 18)

            // Accent divider
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [accent.opacity(0.5), accent.opacity(0.0)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            // Content
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
        .background {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(Theme.card)

                // Subtle accent gradient at top of card
                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [accent.opacity(0.07), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 90)
                    Spacer()
                }
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            }
        }
    }

    @ViewBuilder
    private func supplementList(stack: Stack, accent: Color) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(stack.supplements.enumerated()), id: \.offset) { idx, id in
                if let supp = state.supplement(for: id) {
                    SupplementRow(supplement: supp, accent: accent)
                    if idx < stack.supplements.count - 1 || (stack.optional?.isEmpty == false) {
                        Rectangle()
                            .fill(Theme.separator)
                            .frame(height: 1)
                            .padding(.leading, 52)
                    }
                }
            }

            if let optionals = stack.optional, !optionals.isEmpty {
                ForEach(optionals, id: \.self) { id in
                    if let supp = state.supplement(for: id) {
                        OptionalRow(id: id, supplement: supp, accent: accent)
                        Rectangle()
                            .fill(Theme.separator)
                            .frame(height: 1)
                            .padding(.leading, 52)
                    }
                }
            }
        }
        .padding(.top, 6)
        .padding(.bottom, 6)
    }

    @ViewBuilder
    private func behaviouralNudge(stack: Stack) -> some View {
        let accent = Theme.accent(for: stack.accentColor)
        VStack(alignment: .leading, spacing: 18) {
            Text(stack.notes ?? "No supplements. Just a nudge.")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.white.opacity(0.88))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                logAction()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 13, weight: .semibold))
                    Text("yeah, stepping away")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(accent, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )
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
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )
        }
        .padding(.top, 10)
    }
}

struct SupplementRow: View {
    let supplement: Supplement
    let accent: Color

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // Left accent bar
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(accent.opacity(0.65))
                .frame(width: 2, height: 22)

            VStack(alignment: .leading, spacing: 3) {
                Text(supplement.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)

                Text(supplement.purpose)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Theme.secondary)
            }

            Spacer()

            Text(supplement.dose)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(Theme.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Theme.cardElevated, in: Capsule())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 13)
    }
}

struct OptionalRow: View {
    @Environment(AppState.self) var state
    let id: String
    let supplement: Supplement
    let accent: Color

    var isEnabled: Bool { state.enabledOptionals.contains(id) }

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // Left accent bar (dimmed when disabled)
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(isEnabled ? accent.opacity(0.65) : Theme.separator)
                .frame(width: 2, height: 22)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(supplement.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(isEnabled ? .white : Theme.secondary)

                    Text("optional")
                        .font(.system(size: 9, weight: .semibold, design: .monospaced))
                        .tracking(0.5)
                        .foregroundStyle(Theme.tertiary)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Theme.cardElevated, in: Capsule())
                }

                Text(supplement.purpose)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Theme.tertiary)
            }

            Spacer()

            Button {
                withAnimation(.spring(duration: 0.2)) {
                    state.toggleOptional(id)
                }
            } label: {
                HStack(spacing: 4) {
                    Text(supplement.dose)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(isEnabled ? accent : Theme.tertiary)

                    Image(systemName: isEnabled ? "checkmark.circle.fill" : "plus.circle")
                        .font(.system(size: 14))
                        .foregroundStyle(isEnabled ? accent : Theme.tertiary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    isEnabled ? accent.opacity(0.1) : Theme.cardElevated,
                    in: Capsule()
                )
            }
            .animation(.spring(duration: 0.2), value: isEnabled)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 13)
    }
}
