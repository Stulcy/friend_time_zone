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

            HStack {
                Button("Settings") {
                    openSettings()
                }
                .keyboardShortcut(",", modifiers: .command)

                Spacer()

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q", modifiers: .command)
            }
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

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = friend.timezone
        return formatter.string(from: currentTime)
    }

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

            Text(timeString)
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
