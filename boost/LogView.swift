import SwiftUI
import SwiftData

struct LogView: View {
    @Query(sort: \StackLog.timestamp, order: .reverse) private var logs: [StackLog]
    @Environment(\.modelContext) private var modelContext
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                if logs.isEmpty {
                    emptyState
                } else {
                    logList
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("LOG")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .tracking(5)
                        .foregroundStyle(.white.opacity(0.6))
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "bell")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.secondary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !logs.isEmpty {
                        Button {
                            withAnimation { logs.forEach { modelContext.delete($0) } }
                        } label: {
                            Text("Clear")
                                .font(.system(size: 13))
                                .foregroundStyle(Theme.secondary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                NotificationSettingsSheet()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Theme.card)
                    .frame(width: 56, height: 56)

                Image(systemName: "list.bullet")
                    .font(.system(size: 22))
                    .foregroundStyle(Theme.tertiary)
            }

            VStack(spacing: 6) {
                Text("Nothing logged yet")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.secondary)

                Text("Hit \"boosted!\" on the main screen\nto start your log.")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.tertiary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
        }
        .padding(40)
    }

    private var logList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(groupedLogs, id: \.0) { (day, entries) in
                    Section {
                        ForEach(entries) { entry in
                            LogRow(entry: entry)
                        }
                    } header: {
                        dayHeader(day)
                    }
                }
            }
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
    }

    private var groupedLogs: [(String, [StackLog])] {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"

        var groups: [(String, [StackLog])] = []
        var current: (String, [StackLog])? = nil

        for log in logs {
            let day = fmt.string(from: log.timestamp)
            if current?.0 == day {
                current?.1.append(log)
            } else {
                if let c = current { groups.append(c) }
                current = (day, [log])
            }
        }
        if let c = current { groups.append(c) }
        return groups
    }

    private func dayHeader(_ dayString: String) -> some View {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let displayFmt = DateFormatter()
        displayFmt.dateFormat = "EEEE, MMM d"

        let label: String = {
            guard let date = fmt.date(from: dayString) else { return dayString }
            if Calendar.current.isDateInToday(date) { return "Today" }
            if Calendar.current.isDateInYesterday(date) { return "Yesterday" }
            return displayFmt.string(from: date)
        }()

        return HStack(spacing: 12) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .tracking(2)
                .foregroundStyle(Theme.tertiary)

            Rectangle()
                .fill(Theme.separator)
                .frame(height: 1)
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
        .padding(.bottom, 10)
    }
}

// MARK: - Notification Settings Sheet

struct NotificationSettingsSheet: View {
    @Environment(AppState.self) var appState
    @Environment(NotificationSettings.self) var settings
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 2) {
                        ForEach(appState.data.stacks) { stack in
                            NotifStackRow(stack: stack)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("NOTIFICATIONS")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .tracking(3)
                        .foregroundStyle(.white.opacity(0.6))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        settings.save()
                        NotificationManager.scheduleAll(stacks: appState.data.stacks, settings: settings)
                        dismiss()
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationBackground(Theme.bg)
    }
}

struct NotifStackRow: View {
    @Environment(NotificationSettings.self) var settings
    let stack: Stack

    var isEnabled: Bool { settings.enabled[stack.id] == true }
    var accent: Color { Theme.accent(for: stack.accentColor) }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Text(stack.emoji)
                    .font(.system(size: 20))

                VStack(alignment: .leading, spacing: 2) {
                    Text(stack.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)

                    Text(stack.description)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.tertiary)
                        .lineLimit(1)
                }

                Spacer()

                Toggle("", isOn: Binding(
                    get: { settings.enabled[stack.id] ?? false },
                    set: { settings.enabled[stack.id] = $0 }
                ))
                .tint(accent)
                .labelsHidden()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)

            if isEnabled {
                HStack {
                    Text("Notify at")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.secondary)

                    Spacer()

                    DatePicker(
                        "",
                        selection: Binding(
                            get: { settings.time(for: stack.id) },
                            set: { settings.setTime($0, for: stack.id) }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .colorScheme(.dark)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Theme.card)
            }

            Rectangle()
                .fill(Theme.separator)
                .frame(height: 1)
                .padding(.leading, 20)
        }
        .animation(.spring(duration: 0.25), value: isEnabled)
    }
}

// MARK: - Log Row

struct LogRow: View {
    let entry: StackLog

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // Time column
            Text(entry.timestamp, format: .dateTime.hour().minute())
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundStyle(Theme.tertiary)
                .frame(width: 40, alignment: .leading)

            // Thin vertical separator
            Rectangle()
                .fill(Theme.separator)
                .frame(width: 1, height: 32)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(entry.stackEmoji)
                        .font(.system(size: 13))

                    Text(entry.stackName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                }

                if !entry.supplementNames.isEmpty {
                    Text(entry.supplementNames.joined(separator: "  ·  "))
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.tertiary)
                        .lineLimit(2)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}
