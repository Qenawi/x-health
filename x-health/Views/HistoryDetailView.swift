//
//  HistoryDetailView.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

import SwiftUI
import SwiftData


struct HistoryDetailView: View {
    var record: MedicalRecord
    @State private var showGallery = false
    @State private var selectedImageIndex: Int = 0
    
    // For comparing records.
    @State private var showCompareSheet = false
    @Query(sort: \MedicalRecord.date, order: .reverse) var allRecords: [MedicalRecord]
    @State private var recordToCompare: MedicalRecord? = nil
    
    func loadImage(from file: String) -> UIImage? {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(file)
        return UIImage(contentsOfFile: url.path)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Basic info.
                Group {
                    Text("Record Details")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 4)
                    HStack {
                        Text("Date:")
                            .fontWeight(.bold)
                        Text("\(record.date, formatter: dateFormatter)")
                    }
                    HStack {
                        Text("Type:")
                            .fontWeight(.bold)
                        Text(record.type.rawValue)
                    }
                    if let doctor = record.doctor {
                        HStack {
                            Text("Doctor:")
                                .fontWeight(.bold)
                            Text(doctor.name)
                        }
                    }
                    HStack {
                        Text("Images Attached:")
                            .fontWeight(.bold)
                        Text("\(record.attachedFiles.count)")
                    }
                    if let tag = record.tag {
                        HStack {
                            Text("Tag:")
                                .fontWeight(.bold)
                            Text(tag.name)
                                .foregroundColor(Color(hex: tag.colorHex) ?? .xHealthPrimaryText)
                        }
                    }
                    if !record.bodyParts.isEmpty {
                        HStack {
                            Text("Body Parts:")
                                .fontWeight(.bold)
                            Text(record.bodyParts.joined(separator: ", "))
                        }
                    }
                }
                
                Divider()
                
                // Medicine Section.
                if !record.medicine.isEmpty {
                    Group {
                        Text("Medicine")
                            .font(.headline)
                        Text(record.medicine)
                            .foregroundColor(.xHealthPrimaryText)
                        if let start = record.medicineStartDate, let end = record.medicineEndDate {
                            HStack {
                                Text("Start Date:")
                                    .fontWeight(.bold)
                                Text("\(start, formatter: dateFormatter)")
                            }
                            HStack {
                                Text("End Date:")
                                    .fontWeight(.bold)
                                Text("\(end, formatter: dateFormatter)")
                            }
                        }
                    }
                    Divider()
                }
                
                // Notes.
                Group {
                    Text("Notes")
                        .font(.headline)
                    Text(record.notes)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Divider()
                
                // Images.
                Group {
                    Text("Images")
                        .font(.headline)
                    if record.attachedFiles.isEmpty {
                        Text("No images attached.")
                            .foregroundColor(.gray)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(record.attachedFiles.indices, id: \.self) { index in
                                    if let uiImage = loadImage(from: record.attachedFiles[index]) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(8)
                                            .onTapGesture {
                                                selectedImageIndex = index
                                                showGallery = true
                                            }
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Record Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Compare") {
                    showCompareSheet = true
                }
            }
        }
        .sheet(isPresented: $showGallery) {
            ImageGalleryView(imageFileNames: record.attachedFiles, selectedIndex: $selectedImageIndex)
        }
        .sheet(isPresented: $showCompareSheet) {
            CompareSelectionView(currentRecord: record, allRecords: allRecords.filter { $0.id != record.id }, selectedRecord: $recordToCompare)
        }
        // When a record is chosen for comparison, navigate to CompareRecordsView.
        .fullScreenCover(item: $recordToCompare) { otherRecord in
            CompareRecordsView(record1: record, record2: otherRecord)
        }
    }
}

struct HistoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecord = MedicalRecord(
            type: .doctorVisit,
            date: Date(),
            notes: "This is a sample record note for the detailed view. It shows full text and all sections.",
            attachedFiles: [], // Use valid image filenames if available.
            doctor: Doctor(name: "Dr. Smith", lastVisit: Date()),
            tag: Tag(name: "Routine", colorHex: "#1DB954"),
            bodyParts: ["Left Knee", "Right Shoulder"],
            medicine: "Medicine A, 1 pill daily",
            medicineStartDate: Date().addingTimeInterval(-86400 * 5),
            medicineEndDate: Date().addingTimeInterval(86400 * 5)
        )
        NavigationView {
            HistoryDetailView(record: sampleRecord)
        }
        .preferredColorScheme(.dark)
    }
}
