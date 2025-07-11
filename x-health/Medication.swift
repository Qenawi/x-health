import Foundation
import SwiftData
import UserNotifications

@Model
final class Medication: Identifiable {
    var id: UUID
    var name: String
    var dosage: String
    var reminderTime: Date
    var startDate: Date
    var endDate: Date

    init(name: String, dosage: String, reminderTime: Date, startDate: Date, endDate: Date) {
        self.id = UUID()
        self.name = name
        self.dosage = dosage
        self.reminderTime = reminderTime
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension Medication {
    /// Schedule a daily notification reminder for this medication.
    func scheduleReminder() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }
            let content = UNMutableNotificationContent()
            content.title = "Take \(self.name)"
            content.body = self.dosage
            content.sound = .default

            var components = Calendar.current.dateComponents([.hour, .minute], from: self.reminderTime)
            components.calendar = Calendar.current
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: self.id.uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }

    /// Cancel the scheduled reminder for this medication.
    func cancelReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.id.uuidString])
    }
}
