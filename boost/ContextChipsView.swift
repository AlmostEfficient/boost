import SwiftUI

struct ContextChipsView: View {
    @Environment(AppState.self) var state

    let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("WHAT'S THE SITUATION")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .tracking(2)
                .foregroundStyle(Theme.tertiary)
                .padding(.horizontal, 20)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(state.data.contextModifiers) { modifier in
                    ContextButton(modifier: modifier)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ContextButton: View {
    @Environment(AppState.self) var state
    let modifier: ContextModifier

    var isSelected: Bool { state.selectedContextId == modifier.id }

    var targetStack: Stack? {
        state.data.stacks.first(where: { $0.id == modifier.overridesStack })
    }

    var accent: Color {
        targetStack.map { Theme.accent(for: $0.accentColor) } ?? .white
    }

    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                state.selectContext(modifier.id)
            }
        } label: {
            HStack(spacing: 10) {
                if let emoji = targetStack?.emoji {
                    Text(emoji)
                        .font(.system(size: 18))
                }

                Text(modifier.label)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer()
            }
            .foregroundStyle(isSelected ? .black : .white)
            .padding(.horizontal, 14)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isSelected ? accent : Theme.card)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(
                        isSelected ? accent.opacity(0.0) : Theme.separator,
                        lineWidth: 1
                    )
            }
            .shadow(
                color: isSelected ? accent.opacity(0.22) : .clear,
                radius: 10, y: 4
            )
        }
        .animation(.spring(duration: 0.25), value: isSelected)
    }
}
