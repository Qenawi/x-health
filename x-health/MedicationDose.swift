import Foundation
import SwiftData

@Model
final class MedicationDose: Identifiable {
    enum Status: String, Codable, CaseIterable {
        case pending
        case taken
        case snoozed
        case skipped
    }

    var id: UUID
    var time: Date
    var strength: String
    var quantity: Int
    var notes: String
    var statusRaw: String

    var status: Status {
        get { Status(rawValue: statusRaw) ?? .pending }
        set { statusRaw = newValue.rawValue }
    }

    init(time: Date, strength: String, quantity: Int, notes: String = "", status: Status = .pending) {
        self.id = UUID()
        self.time = time
        self.strength = strength
        self.quantity = quantity
        self.notes = notes
        self.statusRaw = status.rawValue
    }
}
