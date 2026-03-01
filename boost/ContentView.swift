import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) var state
    @Environment(NotificationSettings.self) var notifSettings

    var body: some View {
        MainView()
            .task {
                await NotificationManager.requestPermission()
                NotificationManager.scheduleAll(stacks: state.data.stacks, settings: notifSettings)
            }
    }
}
