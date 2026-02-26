import Foundation
import Observation

@Observable
class NotificationSettings {
    private static let enabledKey = "notif_v1_enabled"
    private static let timesKey   = "notif_v1_times"

    // stackId -> enabled
    var enabled: [String: Bool] = [:]
    // stackId -> minutes since midnight
    private var minutesMap: [String: Int] = [:]

    init(stacks: [Stack]) {
        if let data = UserDefaults.standard.data(forKey: Self.enabledKey),
           let saved = try? JSONDecoder().decode([String: Bool].self, from: data) {
            enabled = saved
        }
        if let data = UserDefaults.standard.data(forKey: Self.timesKey),
           let saved = try? JSONDecoder().decode([String: Int].self, from: data) {
            minutesMap = saved
        }
        // Fill in defaults for any stack not yet stored
        for stack in stacks {
            if enabled[stack.id] == nil { enabled[stack.id] = false }
            if minutesMap[stack.id] == nil {
                minutesMap[stack.id] = parseMinutes(stack.triggerTimes.first ?? "09:00")
            }
        }
    }

    func time(for stackId: String) -> Date {
        minutesToDate(minutesMap[stackId] ?? 9 * 60)
    }

    func setTime(_ date: Date, for stackId: String) {
        let c = Calendar.current.dateComponents([.hour, .minute], from: date)
        minutesMap[stackId] = (c.hour ?? 9) * 60 + (c.minute ?? 0)
    }

    func save() {
        if let data = try? JSONEncoder().encode(enabled) {
            UserDefaults.standard.set(data, forKey: Self.enabledKey)
        }
        if let data = try? JSONEncoder().encode(minutesMap) {
            UserDefaults.standard.set(data, forKey: Self.timesKey)
        }
    }

    private func parseMinutes(_ string: String) -> Int {
        let parts = string.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return 9 * 60 }
        return parts[0] * 60 + parts[1]
    }

    private func minutesToDate(_ minutes: Int) -> Date {
        var c = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        c.hour = minutes / 60
        c.minute = minutes % 60
        return Calendar.current.date(from: c) ?? Date()
    }
}
