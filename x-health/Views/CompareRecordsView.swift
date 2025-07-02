//
//  CompareRecordsView.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

import SwiftUI

import SwiftData

struct CompareRecordsView: View {
    var record1: MedicalRecord
    var record2: MedicalRecord
    @Environment(\.dismiss) var dismiss

    // State variable to hold the file name of the tapped image.
    @State private var selectedImageFile: String? = nil

    /// Helper: Returns the documents directory URL.
    func getDocumentsDirectory() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    /// Helper: Returns an asynchronous image view for a given file name.
    func asyncImageView(for file: String) -> some View {
        if let fileURL = getDocumentsDirectory()?.appendingPathComponent(file) {
            return AnyView(
                AsyncImage(url: fileURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                    case .failure:
                        Text("Error")
                            .frame(width: 100, height: 100)
                    @unknown default:
                        EmptyView()
                    }
                }
                .onTapGesture {
                    // Set the selected image file when tapped.
                    selectedImageFile = file
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                HStack(alignment: .top, spacing: 16) {
                    // Left record.
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Record 1")
                            .font(.headline)
                        // Display the date.
                        Text("Date: \(record1.date, formatter: dateFormatter)")
                            .font(.caption)
                        Text("Type: \(record1.type.rawValue)")
                            .font(.subheadline)
                        if let tag = record1.tag {
                            Text("Tag: \(tag.name)")
                                .font(.caption)
                                .foregroundColor(Color(hex: tag.colorHex) ?? .primary)
                        }
                        if !record1.bodyParts.isEmpty {
                            Text("Body Parts: \(record1.bodyParts.joined(separator: ", "))")
                                .font(.caption)
                        }
                        Text("Description: \(record1.notes)")
                            .lineLimit(3)
                            .font(.body)
                        
                        // Images section for record 1.
                        if !record1.attachedFiles.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(record1.attachedFiles, id: \.self) { file in
                                        asyncImageView(for: file)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Right record.
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Record 2")
                            .font(.headline)
                        // Display the date.
                        Text("Date: \(record2.date, formatter: dateFormatter)")
                            .font(.caption)
                        Text("Type: \(record2.type.rawValue)")
                            .font(.subheadline)
                        if let tag = record2.tag {
                            Text("Tag: \(tag.name)")
                                .font(.caption)
                                .foregroundColor(Color(hex: tag.colorHex) ?? .primary)
                        }
                        if !record2.bodyParts.isEmpty {
                            Text("Body Parts: \(record2.bodyParts.joined(separator: ", "))")
                                .font(.caption)
                        }
                        Text("Description: \(record2.notes)")
                            .lineLimit(3)
                            .font(.body)
                        
                        // Images section for record 2.
                        if !record2.attachedFiles.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(record2.attachedFiles, id: \.self) { file in
                                        asyncImageView(for: file)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .navigationTitle("Compare Records")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .sheet(item: $selectedImageFile) { file in
                ZoomableImageView(imageFileName: file)
            }
        }
        .preferredColorScheme(.dark)
    }
}

extension String: Identifiable {
    public var id: String { self }
}
