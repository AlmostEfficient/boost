import Foundation

enum RhodiolaTracker {
    private static let key = "rhodiola_taken_dates"
    private static let fmt: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static var takenDates: Set<String> {
        get { Set(UserDefaults.standard.stringArray(forKey: key) ?? []) }
        set { UserDefaults.standard.set(Array(newValue), forKey: key) }
    }

    static var todayString: String { fmt.string(from: Date()) }

    static func markTakenToday() {
        var dates = takenDates
        dates.insert(todayString)
        takenDates = dates
    }

    // Count consecutive days taken going backwards from yesterday
    static var consecutiveDaysTakenBeforeToday: Int {
        let calendar = Calendar.current
        var count = 0
        var date = calendar.date(byAdding: .day, value: -1, to: Date())!
        while takenDates.contains(fmt.string(from: date)) {
            count += 1
            date = calendar.date(byAdding: .day, value: -1, to: date)!
        }
        return count
    }

    // True when user has had 5 consecutive on-days and should rest today
    static var shouldSkipToday: Bool {
        guard !takenDates.contains(todayString) else { return false }
        let consecutive = consecutiveDaysTakenBeforeToday
        return consecutive >= 5 && consecutive <= 6
    }

    // How many off-days remain (1 or 2)
    static var offDaysRemaining: Int {
        let consecutive = consecutiveDaysTakenBeforeToday
        if consecutive == 5 { return 2 }
        if consecutive == 6 { return 1 }
        return 0
    }
}
