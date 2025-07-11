import SwiftUI
import SwiftData

struct AddMedicationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var dosage: String = ""
    /// Temporary dose entries for the form. These are converted to `MedicationDose`
    /// objects when the medicine is saved.
    struct DoseEntry: Identifiable {
        var id = UUID()
        var time: Date
        var strength: String
        var quantity: Int
        var notes: String
    }

    @State private var doses: [DoseEntry] = [DoseEntry(time: Date(), strength: "", quantity: 1, notes: "")]

    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var supplyCount: Int = 0
    @State private var refillThreshold: Int = 0
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        Form {
            Section(header: Text("Medicine Details")) {
                TextField("Name", text: $name)
                TextField("Dosage", text: $dosage)
            }

            Section(header: Text("Doses")) {
                ForEach($doses) { $dose in
                    VStack(alignment: .leading) {
                        DatePicker("Dose Time", selection: $dose.time, displayedComponents: .hourAndMinute)
                        TextField("Strength", text: $dose.strength)
                        Stepper(value: $dose.quantity, in: 1...10) {
                            Text("Quantity: \(dose.quantity)")
                        }
                        TextField("Notes", text: $dose.notes)
                    }
                }
                .onDelete { indexSet in
                    doses.remove(atOffsets: indexSet)
                }
                Button(action: { doses.append(DoseEntry(time: Date(), strength: "", quantity: 1, notes: "")) }) {
                    Label("Add Dose", systemImage: "plus")
                }
            }

            Section {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                Stepper(value: $supplyCount, in: 0...1000) { Text("Supply: \(supplyCount)") }
                Stepper(value: $refillThreshold, in: 0...1000) { Text("Refill Alert at: \(refillThreshold)") }
            }

            Button("Save Medicine") {
                do {
                    let medDoses = doses.map { MedicationDose(time: $0.time, strength: $0.strength, quantity: $0.quantity, notes: $0.notes) }
                    let med = Medication(name: name,
                                         dosage: dosage,
                                         doses: medDoses,
                                         startDate: startDate,
                                         endDate: endDate,
                                         supplyCount: supplyCount,
                                         refillThreshold: refillThreshold)
                    modelContext.insert(med)
                    try modelContext.save()
                    med.scheduleReminders()
                    dismiss()
                } catch {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
        .navigationTitle("Add Medicine")
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
}
