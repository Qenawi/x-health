import SwiftUI
import SwiftData
import UserNotifications

struct MedicineTrackerView: View {
    @Query(sort: \Medication.startDate, order: .forward) var medications: [Medication]
    @Environment(\.modelContext) private var modelContext
    @State private var showAdd = false

    var body: some View {
        List {
            ForEach(medications) { med in
                VStack(alignment: .leading) {
                    Text(med.name)
                        .font(.headline)
                    Text(med.dosage)
                        .font(.subheadline)
                    if let firstDose = med.doses.first {
                        HStack {
                            Text("Next: \(firstDose.time, style: .time)")
                            Spacer()
                            Text("Supply: \(med.supplyCount)")
                        }
                    }
                    Text("\(med.startDate, formatter: dateFormatter) - \(med.endDate, formatter: dateFormatter)")
                        .font(.caption)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Medicines")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAdd = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            NavigationView { AddMedicationView() }
        }
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            let med = medications[index]
            med.cancelReminders()
            modelContext.delete(med)
        }
        try? modelContext.save()
    }
}
