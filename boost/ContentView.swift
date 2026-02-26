import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) var state

    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Now", systemImage: "bolt.fill")
                }

            LogView()
                .tabItem {
                    Label("Log", systemImage: "list.bullet")
                }
        }
        .tint(.white)
        .task {
            await NotificationManager.requestPermission()
            NotificationManager.scheduleAll(stacks: state.data.stacks)
        }
    }
}
