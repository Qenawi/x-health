import SwiftUI
import SwiftData
import UserNotifications

struct MedicineTrackerView: View {
    @Query(sort: \Medication.startDate, order: .forward) var medications: [Medication]
    @Environment(\.modelContext) private var modelContext
    @State private var showAdd = false
    @State private var errorMessage: String? = nil
    @State private var selectedMedication: Medication? = nil

    private var todayDoses: [(Medication, MedicationDose)] {
        let today = Calendar.current.startOfDay(for: Date())
        return medications.flatMap { med in
            let start = Calendar.current.startOfDay(for: med.startDate)
            let end = Calendar.current.startOfDay(for: med.endDate)
            guard today >= start && today <= end else { return [] }
            return med.doses.map { (med, $0) }
        }
    }

    var body: some View {
        List {
            if !todayDoses.isEmpty {
                Section(header: Text("Today Log")) {
                    ForEach(todayDoses, id: \.1.id) { pair in
                        let med = pair.0
                        let dose = pair.1
                        HStack {
                            VStack(alignment: .leading) {
                                Text(med.name).font(.headline)
                                Text(dose.strength).font(.caption)
                            }
                            Spacer()
                            Text(dose.time, style: .time)
                            Button(action: { markTaken(med: med, dose: dose) }) {
                                Image(systemName: dose.status == .taken ? "checkmark.circle.fill" : "circle")
                            }
                        }
                    }
                }
            }

            Section(header: Text("Medicines")) {
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
                            }
                        }
                        Text("\(med.startDate, formatter: dateFormatter) - \(med.endDate, formatter: dateFormatter)")
                            .font(.caption)
                    }
                    .onTapGesture { selectedMedication = med }
                }
                .onDelete(perform: delete)
            }
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
            NavigationView {
                AddMedicationView()
            }
            .environment(\.modelContext, modelContext)
        }
        .sheet(item: $selectedMedication) { med in
            NavigationView {
                AddMedicationView(medication: med)
            }
            .environment(\.modelContext, modelContext)
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
