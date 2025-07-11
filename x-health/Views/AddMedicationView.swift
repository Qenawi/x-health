import SwiftUI
import SwiftData

struct AddMedicationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var reminderTime = Date()
    @State private var startDate = Date()
    @State private var endDate = Date()

    var body: some View {
        Form {
            Section(header: Text("Medicine Details")) {
                TextField("Name", text: $name)
                TextField("Dosage", text: $dosage)
                DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
            }
            Button("Save Medicine") {
                let med = Medication(name: name, dosage: dosage, reminderTime: reminderTime, startDate: startDate, endDate: endDate)
                modelContext.insert(med)
                try? modelContext.save()
                med.scheduleReminder()
                dismiss()
            }
        }
        .navigationTitle("Add Medicine")
    }
}
