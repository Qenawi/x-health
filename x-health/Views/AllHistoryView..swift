//
//  AllHistoryView..swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

import Foundation
import SwiftUI
import SwiftData


struct AllHistoryView: View {
    // Explicitly declare the type of modelContext.
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Query(sort: \MedicalRecord.date, order: .reverse) var records: [MedicalRecord]
    @State private var searchText: String = ""
    
    @State private var showDeleteAlert = false
    @State private var passwordInput = ""
    @State private var showShareSheet = false
    @State private var pdfURL: URL? = nil

    var filteredRecords: [MedicalRecord] {
        if searchText.isEmpty {
            return records
        } else {
            let query = searchText.lowercased()
            return records.filter { record in
                let notesMatch = record.notes.lowercased().contains(query)
                let tagMatch = record.tag?.name.lowercased().contains(query) ?? false
                let bodyPartsMatch = record.bodyParts.contains { $0.lowercased().contains(query) }
                let doctorMatch = record.doctor?.name.lowercased().contains(query) ?? false
                return notesMatch || tagMatch || bodyPartsMatch || doctorMatch
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.xHealthBackground.edgesIgnoringSafeArea(.all)
            VStack {
                Text("All History")
                    .font(.largeTitle)
                    .foregroundColor(.xHealthPrimaryText)
                    .padding()
                
                if filteredRecords.isEmpty && !searchText.isEmpty {
                    // Placeholder view when no matching records are found.
                    VStack(spacing: 16) {
                        LogoView()
                        Text("Nothing matched your search.")
                            .foregroundColor(.xHealthSecondaryText)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(filteredRecords) { record in
                                NavigationLink(destination: HistoryDetailView(record: record)) {
                                    HistoryItem(record: record)
                                        .transition(.opacity.combined(with: .slide))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                        .animation(.easeInOut, value: filteredRecords.count)
                    }
                }
            }
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search by tag, description, body part, or doctor"
        )
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Export PDF") {
                    if let url = exportRecordsAsPDF() {
                        pdfURL = url
                        showShareSheet = true
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Delete All") {
                    showDeleteAlert = true
                }
            }
        }
        .alert("Enter Password", isPresented: $showDeleteAlert, actions: {
            SecureField("Password", text: $passwordInput)
            Button("OK") {
                if passwordInput == "1234" {
                    deleteAllRecords()
                }
                passwordInput = ""
            }
            Button("Cancel", role: .cancel) {
                passwordInput = ""
            }
        }, message: {
            Text("Please enter the password to delete all records.")
        })
        .sheet(isPresented: $showShareSheet, content: {
            if let pdfURL = pdfURL {
                ActivityView(activityItems: [pdfURL])
            }
        })
    }
    
    // MARK: - Helper Functions
    
    /// Deletes all records.
    func deleteAllRecords() {
        for record in records {
            modelContext.delete(record)
        }
        try? modelContext.save()
    }
    
    /// Returns the Documents directory URL.
    func getDocumentsDirectory() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    /// Exports all records as a single PDF file.
    func exportRecordsAsPDF() -> URL? {
        let pageWidth: CGFloat = 595.2 // A4 width in points
        let pageHeight: CGFloat = 841.8 // A4 height in points
        let pdfMetaData = [
            kCGPDFContextCreator: "x_healthApp",
            kCGPDFContextAuthor: "x_healthApp"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        // Create a temporary file URL for the PDF.
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Records.pdf")
        do {
            try renderer.writePDF(to: url, withActions: { (context) in
                // If no records, generate a page with a message.
                if records.isEmpty {
                    context.beginPage()
                    let message = "No records available."
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 18),
                        .foregroundColor: UIColor.white
                    ]
                    let attributedMessage = NSAttributedString(string: message, attributes: attributes)
                    let messageRect = CGRect(x: 20, y: 20, width: pageWidth - 40, height: 50)
                    attributedMessage.draw(in: messageRect)
                } else {
                    // For each record, create a page.
                    for record in records {
                        context.beginPage()
                        
                        // Draw record details text.
                        let text = """
                        Date: \(dateFormatter.string(from: record.date))
                        Type: \(record.type.rawValue)
                        Notes: \(record.notes)
                        """
                        let attributes: [NSAttributedString.Key: Any] = [
                            .font: UIFont.systemFont(ofSize: 14),
                            .foregroundColor: UIColor.white
                        ]
                        let attributedText = NSAttributedString(string: text, attributes: attributes)
                        let textRect = CGRect(x: 20, y: 20, width: pageWidth - 40, height: 100)
                        attributedText.draw(in: textRect)
                        
                        // Draw body parts if available.
                        if !record.bodyParts.isEmpty {
                            let bodyPartsText = "Body Parts: " + record.bodyParts.joined(separator: ", ")
                            let attributedBP = NSAttributedString(string: bodyPartsText, attributes: attributes)
                            let bpRect = CGRect(x: 20, y: 130, width: pageWidth - 40, height: 50)
                            attributedBP.draw(in: bpRect)
                        }
                        
                        // Draw tag if available.
                        if let tag = record.tag {
                            let tagText = "Tag: \(tag.name)"
                            let attributedTag = NSAttributedString(string: tagText, attributes: attributes)
                            let tagRect = CGRect(x: 20, y: 190, width: pageWidth - 40, height: 30)
                            attributedTag.draw(in: tagRect)
                        }
                        
                        // Draw doctor's name if available.
                        if let doctor = record.doctor {
                            let doctorText = "Doctor: \(doctor.name)"
                            let attributedDoctor = NSAttributedString(string: doctorText, attributes: attributes)
                            let docRect = CGRect(x: 20, y: 230, width: pageWidth - 40, height: 30)
                            attributedDoctor.draw(in: docRect)
                        }
                        
                        // Draw images.
                        var imageY: CGFloat = 270
                        for file in record.attachedFiles {
                            if let dir = getDocumentsDirectory() {
                                let imageURL = dir.appendingPathComponent(file)
                                if let image = UIImage(contentsOfFile: imageURL.path) {
                                    let aspectRatio = image.size.width / image.size.height
                                    let imageWidth = pageWidth - 40
                                    let imageHeight = imageWidth / aspectRatio
                                    let imageRect = CGRect(x: 20, y: imageY, width: imageWidth, height: imageHeight)
                                    image.draw(in: imageRect)
                                    imageY += imageHeight + 10
                                }
                            }
                        }
                    }
                }
            })
            return url
        } catch {
            print("Error creating PDF: \(error)")
            return nil
        }
    }

}


struct AllHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllHistoryView()
        }
        .preferredColorScheme(.dark)
    }
}


struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
