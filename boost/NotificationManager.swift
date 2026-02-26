import UserNotifications
import Foundation

enum NotificationManager {
    static func requestPermission() async {
        _ = try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
    }

    static func scheduleAll(stacks: [Stack], settings: NotificationSettings) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        for stack in stacks {
            guard settings.enabled[stack.id] == true else { continue }

            let time = settings.time(for: stack.id)
            let c = Calendar.current.dateComponents([.hour, .minute], from: time)

            let content = UNMutableNotificationContent()
            content.title = "\(stack.emoji) \(stack.name)"
            content.body = stack.description
            content.sound = .default

            var components = DateComponents()
            components.hour = c.hour
            components.minute = c.minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(
                identifier: stack.id,
                content: content,
                trigger: trigger
            )
            center.add(request)
        }
    }
}
