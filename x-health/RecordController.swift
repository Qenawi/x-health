//
//  RecordController.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

// RecordController.swift
import Foundation
import UIKit

class RecordController: ObservableObject {
    @Published var records: [MedicalRecord] = []
    
    // Add a new record.
    func addRecord(_ record: MedicalRecord) {
        records.append(record)
    }
    
    // MARK: - Image Saving Helpers
    
    /// Returns the app's Documents directory if available.
    func getDocumentsDirectory() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    /// Saves a UIImage as a JPEG to the Documents directory and returns the filename.
    func saveImage(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8),
              let documentsURL = getDocumentsDirectory() else {
            return nil
        }

        let fileName = UUID().uuidString + ".jpg"
        let url = documentsURL.appendingPathComponent(fileName)
        do {
            try data.write(to: url)
            print("Saved image at \(url)")
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
}


