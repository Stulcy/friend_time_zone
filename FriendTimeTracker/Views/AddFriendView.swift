import SwiftUI

struct AddFriendView: View {
    @EnvironmentObject var friendStore: FriendStore
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var selectedTimezone = TimeZone.current.identifier

    private var previewTime: String? {
        guard let tz = TimeZone(identifier: selectedTimezone) else { return nil }
        let formatter = DateFormatter()
        formatter.timeZone = tz
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Add Friend")
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

            if let time = previewTime {
                Text("Current time: \(time)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Add") {
                    friendStore.addFriend(name: name, timezoneIdentifier: selectedTimezone)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty)
            }
        }
        .padding()
        .frame(width: 400, height: 280)
    }
}
