import SwiftUI
import SwiftData

@main
struct boostApp: App {
    let appState = AppState(data: DataLoader.load())

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([StackLog.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
    }
}
