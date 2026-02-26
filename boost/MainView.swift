import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(AppState.self) var state
    @Environment(\.modelContext) private var modelContext
    @State private var loggedConfirm = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Time + state header
                    headerView
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 16)

                    // Main stack card
                    ScrollView {
                        StackCardView(logAction: logCurrentStack)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)

                        // Context chips
                        ContextChipsView()
                            .padding(.bottom, 24)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("BOOST")
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .tracking(4)
                        .foregroundStyle(.white)
                }
            }
        }
        .overlay(alignment: .top) {
            if loggedConfirm {
                logConfirmBanner
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(10)
            }
        }
    }

    private var headerView: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(Date(), format: .dateTime.hour().minute())
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                if state.selectedContextId != nil {
                    HStack(spacing: 6) {
                        Text("OVERRIDE")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .tracking(2)
                            .foregroundStyle(Theme.accent(for: state.currentStack.accentColor))

                        Button {
                            withAnimation(.spring(duration: 0.3)) {
                                state.clearContext()
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Theme.secondary)
                        }
                    }
                } else {
                    Text(state.currentStack.state.label)
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                        .foregroundStyle(Theme.accent(for: state.currentStack.accentColor))
                }
            }

            Spacer()

            // Rhodiola cycling warning
            if RhodiolaTracker.shouldSkipToday {
                VStack(alignment: .trailing, spacing: 2) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(red: 1.0, green: 0.7, blue: 0.28))

                    Text("Rhodiola off")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Theme.secondary)

                    Text("\(RhodiolaTracker.offDaysRemaining)d remain")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundStyle(Theme.tertiary)
                }
            }
        }
    }

    private var logConfirmBanner: some View {
        Text("boosted ✓")
            .font(.system(size: 13, weight: .semibold, design: .monospaced))
            .tracking(1)
            .foregroundStyle(.black)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.white, in: Capsule())
            .padding(.top, 60)
    }

    private func logCurrentStack() {
        let supplementNames = state.activeSupplementIds.compactMap {
            state.supplement(for: $0)?.name
        }

        let log = StackLog(
            stackId: state.currentStack.id,
            stackName: state.currentStack.name,
            stackEmoji: state.currentStack.emoji,
            supplementNames: supplementNames
        )
        modelContext.insert(log)

        // Mark Rhodiola if it's in the active stack
        if state.activeSupplementIds.contains("rhodiola") {
            RhodiolaTracker.markTakenToday()
        }

        withAnimation(.spring(duration: 0.3)) {
            loggedConfirm = true
        }
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation {
                loggedConfirm = false
            }
        }
    }
}
