import Foundation
import SwiftUI
import os.log

@MainActor
class FriendStore: ObservableObject {
    @Published var friends: [Friend] = []

    private let saveKey = "savedFriends"
    private let logger = Logger(subsystem: "com.friendtimetracker.app", category: "persistence")

    init() {
        loadFriends()
    }

    func loadFriends() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else {
            logger.debug("No saved friends data found")
            return
        }
        do {
            friends = try JSONDecoder().decode([Friend].self, from: data)
            logger.info("Loaded \(self.friends.count) friends")
        } catch {
            logger.error("Failed to decode friends: \(error.localizedDescription)")
        }
    }

    func saveFriends() {
        do {
            let encoded = try JSONEncoder().encode(friends)
            UserDefaults.standard.set(encoded, forKey: saveKey)
            logger.debug("Saved \(self.friends.count) friends")
        } catch {
            logger.error("Failed to encode friends: \(error.localizedDescription)")
        }
    }

    func addFriend(name: String, timezoneIdentifier: String) {
        let friend = Friend(name: name, timezoneIdentifier: timezoneIdentifier)
        friends.append(friend)
        saveFriends()
    }

    func removeFriend(_ friend: Friend) {
        friends.removeAll { $0.id == friend.id }
        saveFriends()
    }

    func updateFriend(_ friend: Friend, name: String, timezoneIdentifier: String) {
        if let index = friends.firstIndex(where: { $0.id == friend.id }) {
            friends[index].name = name
            friends[index].timezoneIdentifier = timezoneIdentifier
            saveFriends()
        }
    }

    func moveFriends(from source: IndexSet, to destination: Int) {
        friends.move(fromOffsets: source, toOffset: destination)
        saveFriends()
    }

    static let availableTimezones: [(identifier: String, displayName: String)] = {
        TimeZone.knownTimeZoneIdentifiers
            .sorted()
            .map { identifier in
                let tz = TimeZone(identifier: identifier)
                let offsetSeconds = tz?.secondsFromGMT() ?? 0
                let hours = offsetSeconds / 3600
                let minutes = abs(offsetSeconds % 3600) / 60
                let offsetString = String(format: "GMT%+03d:%02d", hours, minutes)
                let displayName = identifier.replacingOccurrences(of: "_", with: " ")
                return (identifier, "\(displayName) (\(offsetString))")
            }
    }()
}
