import SwiftUI

@main
struct FriendTimeTrackerApp: App {
    @StateObject private var friendStore = FriendStore()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .environmentObject(friendStore)
        } label: {
            Image(systemName: "globe.desk")
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
                .environmentObject(friendStore)
        }
    }
}
