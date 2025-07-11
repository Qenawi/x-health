import SwiftUI
import SwiftData
import UserNotifications

struct MedicineTrackerView: View {
    @Query(sort: \Medication.startDate, order: .forward) var medications: [Medication]
    @Environment(\.modelContext) private var modelContext
    @State private var showAdd = false
    @State private var errorMessage: String? = nil

    var body: some View {
        List {
            ForEach(medications) { med in
                VStack(alignment: .leading) {
                    Text(med.name)
                        .font(.headline)
                    Text(med.dosage)
                        .font(.subheadline)
                    if let nextDose = med.doses.first(where: { $0.status != .taken }) {
                        HStack {
                            Text("Next: \(nextDose.time, style: .time)")
                            Spacer()
                            Button(action: { markTaken(med: med, dose: nextDose) }) {
                                Image(systemName: nextDose.status == .taken ? "checkmark.circle.fill" : "circle")
                            }
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
        .alert("Error", isPresented: .constant(errorMessage != nil), actions: {
            Button("OK", role: .cancel) { errorMessage = nil }
        }, message: {
            Text(errorMessage ?? "")
        })
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            let med = medications[index]
            med.cancelReminders()
            modelContext.delete(med)
        }
        do {
            try modelContext.save()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func markTaken(med: Medication, dose: MedicationDose) {
        med.mark(dose: dose, status: .taken)
        do {
            try modelContext.save()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
