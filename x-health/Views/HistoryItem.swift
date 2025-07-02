//
//  HistoryItem.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

// HistoryItem.swift
import SwiftUI

struct HistoryItem: View {
    var record: MedicalRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Date
            Text("\(record.date, formatter: dateFormatter)")
                .foregroundColor(.xHealthSecondaryText)
                .font(.subheadline)
            
            // Record Type
            Text("Type: \(record.type.rawValue)")
                .foregroundColor(.xHealthPrimaryText)
                .font(.headline)
            
            // Images count
            Text("Images Attached: \(record.attachedFiles.count)")
                .foregroundColor(.xHealthPrimaryText)
                .font(.caption)
            
            // Tag (if available) with text colored by the tag's color.
            if let tag = record.tag {
                Text("Tag: \(tag.name)")
                    .foregroundColor(Color(hex: tag.colorHex) ?? .xHealthPrimaryText)
                    .font(.caption)
            }
            
            // Body parts (if any)
            if !record.bodyParts.isEmpty {
                Text("Body Parts: \(record.bodyParts.joined(separator: ", "))")
                    .foregroundColor(.xHealthSecondaryText)
                    .font(.caption)
            }
            
            // Notes (limited to two lines)
            Text(record.notes)
                .foregroundColor(.xHealthPrimaryText)
                .font(.body)
                .lineLimit(2)
            
            // Doctor (if available)
            if let doc = record.doctor {
                Text("Doctor: \(doc.name)")
                    .foregroundColor(.xHealthSecondaryText)
                    .font(.caption)
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading) // Ensures full-width.
        .background(Color.xHealthBackground)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct HistoryItem_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample record for preview purposes.
        let sampleRecord = MedicalRecord(
            type: .doctorVisit,
            date: Date(),
            notes: "This is a sample record note that is meant to display in the history item view.",
            attachedFiles: ["sampleImage.jpg"], // Use a valid image filename if available.
            doctor: Doctor(name: "Dr. Smith", lastVisit: Date()),
            tag: Tag(name: "Routine", colorHex: "#1DB954"),
            bodyParts: ["Left Knee", "Right Shoulder"]
        )
        HistoryItem(record: sampleRecord)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
