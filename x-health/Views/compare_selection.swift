//
//  compare_selection.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

// Views/CompareSelectionView.swift
import SwiftUI
import SwiftData


struct CompareSelectionView: View {
    var currentRecord: MedicalRecord
    var allRecords: [MedicalRecord]
    @Binding var selectedRecord: MedicalRecord?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List(allRecords) { record in
                Button(action: {
                    selectedRecord = record
                    dismiss()
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        
                        // Title using record type.
                        Text("Date:")
                            .fontWeight(.bold)
                        Text("\(record.date, formatter: dateFormatter)")
                        // Title using record type.
                        Text(record.type.rawValue)
                            .font(.headline)
                        // Description: truncated notes.
                        Text(record.notes)
                            .font(.subheadline)
                            .lineLimit(2)
                        // Tag (if available)
                        if let tag = record.tag {
                            Text("Tag: \(tag.name)")
                                .font(.caption)
                                .foregroundColor(Color(hex: tag.colorHex) ?? .primary)
                        }
                        // Body parts (if available)
                        if !record.bodyParts.isEmpty {
                            Text("Body Parts: \(record.bodyParts.joined(separator: ", "))")
                                .font(.caption)
                        }
                    }
                    .padding(4)
                }
            }
            .navigationTitle("Select Record to Compare")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

struct CompareSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleDoctor = Doctor(name: "Dr. Sample", lastVisit: Date())
        let sampleTag = Tag(name: "Routine", colorHex: "#1DB954")
        let record1 = MedicalRecord(
            type: .doctorVisit,
            date: Date(),
            notes: "Record one notes for comparison.",
            attachedFiles: [],
            doctor: sampleDoctor,
            tag: sampleTag,
            bodyParts: ["Left Knee", "Neck"]
        )
        let record2 = MedicalRecord(
            type: .labResult,
            date: Date().addingTimeInterval(-86400),
            notes: "Record two notes, with additional details.",
            attachedFiles: [],
            doctor: sampleDoctor,
            tag: sampleTag,
            bodyParts: ["Right Shoulder"]
        )
        CompareSelectionView(currentRecord: record1, allRecords: [record2], selectedRecord: .constant(nil))
    }
}
