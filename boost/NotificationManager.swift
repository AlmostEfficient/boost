import UserNotifications
import Foundation

enum NotificationManager {
    static func requestPermission() async {
        _ = try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
    }

    static func scheduleAll(stacks: [Stack]) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        for stack in stacks {
            for time in stack.triggerTimes {
                let parts = time.split(separator: ":").compactMap { Int($0) }
                guard parts.count == 2 else { continue }

                let content = UNMutableNotificationContent()
                content.title = "\(stack.emoji) \(stack.name)"
                content.body = stack.description
                content.sound = .default

                var components = DateComponents()
                components.hour = parts[0]
                components.minute = parts[1]

                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: components,
                    repeats: true
                )
                let request = UNNotificationRequest(
                    identifier: "\(stack.id)-\(time)",
                    content: content,
                    trigger: trigger
                )
                center.add(request)
            }
        }
    }
}
