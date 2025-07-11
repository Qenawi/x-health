import Foundation
import SwiftData
import UserNotifications

@Model
final class Medication: Identifiable {
    var id: UUID
    var name: String
    var dosage: String
    var doses: [MedicationDose] = []
    var startDate: Date
    var endDate: Date
    var supplyCount: Int
    var refillThreshold: Int

    init(name: String,
         dosage: String,
         doses: [MedicationDose] = [],
         startDate: Date,
         endDate: Date,
         supplyCount: Int = 0,
         refillThreshold: Int = 0) {
        self.id = UUID()
        self.name = name
        self.dosage = dosage
        self.doses = doses
        self.startDate = startDate
        self.endDate = endDate
        self.supplyCount = supplyCount
        self.refillThreshold = refillThreshold
    }
}

extension Medication {
    /// Schedule notifications for all doses of this medication.
    func scheduleReminders() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }

            for dose in self.doses {
                let content = UNMutableNotificationContent()
                content.title = "Take \(self.name)"
                content.body = "\(dose.quantity) \(self.dosage) - \(dose.strength)"
                content.sound = .default

                var components = Calendar.current.dateComponents([.hour, .minute], from: dose.time)
                components.calendar = Calendar.current
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: dose.id.uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }

    /// Cancel all scheduled reminders for this medication.
    func cancelReminders() {
        let ids = doses.map { $0.id.uuidString }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }

    /// Mark a dose with a new status and update supply count.
    func mark(dose: MedicationDose, status: MedicationDose.Status) {
        guard let index = doses.firstIndex(where: { $0.id == dose.id }) else { return }
        doses[index].status = status
        if status == .taken {
            supplyCount -= doses[index].quantity
            checkRefill()
        }
    }

    /// Check if supply is below threshold and trigger refill reminder.
    func checkRefill() {
        guard supplyCount <= refillThreshold else { return }
        let content = UNMutableNotificationContent()
        content.title = "Time to Refill"
        content.body = "\(name) is running low"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "refill-\(id.uuidString)", content: content, trigger: trigger), withCompletionHandler: nil)
    }
}
