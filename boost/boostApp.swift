import SwiftUI
import SwiftData

@main
struct boostApp: App {
    let appState: AppState
    let notifSettings: NotificationSettings

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([StackLog.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    init() {
        let data = DataLoader.load()
        appState = AppState(data: data)
        notifSettings = NotificationSettings(stacks: data.stacks)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(notifSettings)
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
    }
}
