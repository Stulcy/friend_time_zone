import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @EnvironmentObject var friendStore: FriendStore
    @State private var showingAddSheet = false
    @State private var friendToEdit: Friend?
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled

    var body: some View {
        VStack(spacing: 0) {
            Toggle("Launch at Login", isOn: $launchAtLogin)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .onChange(of: launchAtLogin) { _, newValue in
                    do {
                        if newValue {
                            try SMAppService.mainApp.register()
                        } else {
                            try SMAppService.mainApp.unregister()
                        }
                    } catch {
                        launchAtLogin = !newValue
                    }
                }

            Divider()

            if friendStore.friends.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "person.2")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No friends added yet")
                        .font(.headline)
                    Text("Click the + button to add a friend")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(friendStore.friends) { friend in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(friend.name)
                                    .font(.headline)
                                Text(friend.timezoneIdentifier.replacingOccurrences(of: "_", with: " "))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Text(friend.currentTime)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)

                            Button(action: {
                                friendStore.removeFriend(friend)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                            .help("Delete friend")
                        }
                        .contentShape(Rectangle())
                        .contextMenu {
                            Button("Edit") {
                                friendToEdit = friend
                            }
                            Button("Delete", role: .destructive) {
                                friendStore.removeFriend(friend)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            friendStore.removeFriend(friendStore.friends[index])
                        }
                    }
                    .onMove { source, destination in
                        friendStore.moveFriends(from: source, to: destination)
                    }
                }
            }

            Divider()

            HStack {
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                }
                .help("Add Friend")

                Spacer()

                Text("\(friendStore.friends.count) friend\(friendStore.friends.count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(8)
        }
        .frame(width: 400, height: 350)
        .sheet(isPresented: $showingAddSheet) {
            AddFriendView()
        }
        .sheet(item: $friendToEdit) { friend in
            EditFriendView(friend: friend)
        }
    }
}

struct EditFriendView: View {
    @EnvironmentObject var friendStore: FriendStore
    @Environment(\.dismiss) private var dismiss
    let friend: Friend

    @State private var name: String = ""
    @State private var selectedTimezone: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Edit Friend")
                .font(.headline)

            Form {
                TextField("Name", text: $name)

                Picker("Timezone", selection: $selectedTimezone) {
                    ForEach(FriendStore.availableTimezones, id: \.identifier) { tz in
                        Text(tz.displayName)
                            .tag(tz.identifier)
                    }
                }
            }
            .formStyle(.grouped)

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Save") {
                    friendStore.updateFriend(friend, name: name, timezoneIdentifier: selectedTimezone)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty)
            }
        }
        .padding()
        .frame(width: 400)
        .onAppear {
            name = friend.name
            selectedTimezone = friend.timezoneIdentifier
        }
    }
}
