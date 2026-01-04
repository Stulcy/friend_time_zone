import Foundation

struct Friend: Identifiable, Codable, Hashable {
    private static let shortTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    private static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d 'at' h:mm a"
        return formatter
    }()

    var id = UUID()
    var name: String
    var timezoneIdentifier: String

    var timezone: TimeZone? {
        TimeZone(identifier: timezoneIdentifier)
    }

    var currentTime: String {
        Self.shortTimeFormatter.timeZone = timezone
        return Self.shortTimeFormatter.string(from: Date())
    }

    var currentTimeWithDate: String {
        Self.dateTimeFormatter.timeZone = timezone
        return Self.dateTimeFormatter.string(from: Date())
    }

    var timezoneAbbreviation: String {
        timezone?.abbreviation() ?? timezoneIdentifier
    }
}
