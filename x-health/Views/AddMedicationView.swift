import SwiftUI
import SwiftData

struct AddMedicationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var doseTime = Date()
    @State private var strength: String = ""
    @State private var quantity: Int = 1
    @State private var notes: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var supplyCount: Int = 0
    @State private var refillThreshold: Int = 0

    var body: some View {
        Form {
            Section(header: Text("Medicine Details")) {
                TextField("Name", text: $name)
                TextField("Dosage", text: $dosage)
                DatePicker("Dose Time", selection: $doseTime, displayedComponents: .hourAndMinute)
                TextField("Strength", text: $strength)
                Stepper(value: $quantity, in: 1...10) {
                    Text("Quantity: \(quantity)")
                }
                TextField("Notes", text: $notes)
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                Stepper(value: $supplyCount, in: 0...1000) { Text("Supply: \(supplyCount)") }
                Stepper(value: $refillThreshold, in: 0...1000) { Text("Refill Alert at: \(refillThreshold)") }
            }
            Button("Save Medicine") {
                let dose = MedicationDose(time: doseTime, strength: strength, quantity: quantity, notes: notes)
                let med = Medication(name: name,
                                     dosage: dosage,
                                     doses: [dose],
                                     startDate: startDate,
                                     endDate: endDate,
                                     supplyCount: supplyCount,
                                     refillThreshold: refillThreshold)
                modelContext.insert(med)
                try? modelContext.save()
                med.scheduleReminders()
                dismiss()
            }
        }
        .navigationTitle("Add Medicine")
    }
}
