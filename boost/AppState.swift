import Foundation
import Observation

@Observable
class AppState {
    let data: BoostData
    var selectedContextId: String? = nil
    var enabledOptionals: Set<String> = []
    var dailyLoggedToday: Bool

    init(data: BoostData) {
        self.data = data
        if let lastDate = UserDefaults.standard.object(forKey: "dailyLoggedDate") as? Date {
            self.dailyLoggedToday = Calendar.current.isDateInToday(lastDate)
        } else {
            self.dailyLoggedToday = false
        }
    }

    func markDailyLogged() {
        UserDefaults.standard.set(Date(), forKey: "dailyLoggedDate")
        dailyLoggedToday = true
    }

    var currentStack: Stack {
        if let contextId = selectedContextId,
           let modifier = data.contextModifiers.first(where: { $0.id == contextId }),
           let stack = data.stacks.first(where: { $0.id == modifier.overridesStack }) {
            return stack
        }
        if !dailyLoggedToday,
           let daily = data.stacks.first(where: { $0.id == "daily_lunch" }) {
            return daily
        }
        return timeBasedStack
    }

    // The stack inferred from the current time
    var timeBasedStack: Stack {
        let calendar = Calendar.current
        let now = Date()
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        let currentMinutes = hour * 60 + minute

        var bestMinutes = -1
        var bestStack: Stack? = nil

        for td in data.timeDefaults {
            let parts = td.time.split(separator: ":").compactMap { Int($0) }
            guard parts.count == 2 else { continue }
            let mins = parts[0] * 60 + parts[1]
            if mins <= currentMinutes && mins > bestMinutes {
                bestMinutes = mins
                bestStack = data.stacks.first(where: { $0.id == td.defaultStack })
            }
        }

        // Before first time slot: show the morning stack
        return bestStack ?? data.stacks.first(where: { $0.id == "morning_baseline" }) ?? data.stacks[0]
    }

    // Supplements to display: base + enabled optionals
    var activeSupplementIds: [String] {
        var ids = currentStack.supplements
        for opt in (currentStack.optional ?? []) {
            if enabledOptionals.contains(opt) {
                ids.append(opt)
            }
        }
        return ids
    }

    func supplement(for id: String) -> Supplement? {
        data.supplements[id]
    }

    func selectContext(_ id: String) {
        if selectedContextId == id {
            selectedContextId = nil
        } else {
            selectedContextId = id
            enabledOptionals = []
        }
    }

    func toggleOptional(_ id: String) {
        if enabledOptionals.contains(id) {
            enabledOptionals.remove(id)
        } else {
            enabledOptionals.insert(id)
        }
    }

    func clearContext() {
        selectedContextId = nil
        enabledOptionals = []
    }
}
