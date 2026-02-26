import SwiftUI
import SwiftData

struct LogView: View {
    @Query(sort: \StackLog.timestamp, order: .reverse) private var logs: [StackLog]
    @Environment(\.modelContext) private var modelContext

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
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .tracking(4)
                        .foregroundStyle(.white)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    if !logs.isEmpty {
                        Button {
                            withAnimation {
                                logs.forEach { modelContext.delete($0) }
                            }
                        } label: {
                            Text("Clear")
                                .font(.system(size: 13))
                                .foregroundStyle(Theme.secondary)
                        }
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("—")
                .font(.system(size: 40))
                .foregroundStyle(Theme.tertiary)

            Text("Nothing logged yet")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Theme.secondary)

            Text("Hit \"boosted!\" on the main screen\nto start your log.")
                .font(.system(size: 13))
                .foregroundStyle(Theme.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }

    private var logList: some View {
        ScrollView {
            LazyVStack(spacing: 1) {
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

    // Group by calendar day
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

        return HStack {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .tracking(2)
                .foregroundStyle(Theme.tertiary)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 8)
    }
}

struct LogRow: View {
    let entry: StackLog

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .trailing, spacing: 2) {
                Text(entry.timestamp, format: .dateTime.hour().minute())
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundStyle(Theme.secondary)
            }
            .frame(width: 44)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(entry.stackEmoji)
                        .font(.system(size: 14))

                    Text(entry.stackName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                }

                if !entry.supplementNames.isEmpty {
                    Text(entry.supplementNames.joined(separator: "  ·  "))
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(Theme.tertiary)
                        .lineLimit(2)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Theme.bg)
    }
}
