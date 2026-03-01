import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(AppState.self) var state
    @Environment(\.modelContext) private var modelContext
    @State private var loggedConfirm = false
    @State private var showingLog = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                // Ambient accent glow at top
                VStack {
                    RadialGradient(
                        colors: [
                            Theme.accent(for: state.currentStack.accentColor).opacity(0.10),
                            .clear
                        ],
                        center: .top,
                        startRadius: 0,
                        endRadius: 220
                    )
                    .frame(height: 220)
                    .ignoresSafeArea()
                    Spacer()
                }
                .animation(.easeInOut(duration: 0.6), value: state.currentStack.id)

                VStack(spacing: 0) {
                    headerView
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 16)

                    ScrollView {
                        StackCardView(logAction: logCurrentStack, hasLogged: loggedConfirm)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)

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
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .tracking(5)
                        .foregroundStyle(.white.opacity(0.6))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingLog = true
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.secondary)
                    }
                }
            }
            .sheet(isPresented: $showingLog) {
                LogView()
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
            VStack(alignment: .leading, spacing: 4) {
                if state.selectedContextId != nil {
                    HStack(spacing: 6) {
                        Text("OVERRIDE")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
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
                    HStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 1.5)
                            .fill(Theme.accent(for: state.currentStack.accentColor))
                            .frame(width: 12, height: 2)

                        Text(state.currentStack.state.label)
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .tracking(2)
                            .foregroundStyle(Theme.accent(for: state.currentStack.accentColor))
                    }
                }
            }

            Spacer()

            if RhodiolaTracker.shouldSkipToday {
                VStack(alignment: .trailing, spacing: 3) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(red: 1.0, green: 0.7, blue: 0.28))

                    Text("Rhodiola off")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Theme.secondary)

                    Text("\(RhodiolaTracker.offDaysRemaining)d remain")
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                        .foregroundStyle(Theme.tertiary)
                }
                .padding(10)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }

    private var logConfirmBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark")
                .font(.system(size: 11, weight: .bold))
            Text("boosted")
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .tracking(1)
        }
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

        if state.currentStack.id == "daily_lunch" {
            state.markDailyLogged()
        }

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
