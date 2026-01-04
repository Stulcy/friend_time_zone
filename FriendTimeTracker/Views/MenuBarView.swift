import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var friendStore: FriendStore
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if friendStore.friends.isEmpty {
                Text("No friends added yet")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(friendStore.friends) { friend in
                    FriendTimeRow(friend: friend)
                }
            }

            Divider()
                .padding(.vertical, 4)

            Button("Settings") {
                openSettings()
            }
            .keyboardShortcut(",", modifiers: .command)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
        }
        .padding(.vertical, 8)
        .frame(minWidth: 250)
    }
}

struct FriendTimeRow: View {
    let friend: Friend
    @State private var currentTime = Date()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(friend.name)
                    .font(.headline)
                Text(friend.timezoneAbbreviation)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(friend.currentTime)
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
}
