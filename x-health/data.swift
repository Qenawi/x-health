//
//  data.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

import Foundation

// Models.swift
import SwiftData
import SwiftUI

@Model
final class MedicalRecord {
    var id: UUID = UUID()
    var type: RecordType
    var date: Date
    var notes: String
    var attachedFiles: [String] = [] // Filenames for images/documents
    var doctor: Doctor?
    var tag: Tag?
    var bodyParts: [String] = []
    
    // New medicine-related fields
    var medicine: String = ""
    var medicineStartDate: Date?
    var medicineEndDate: Date?
    
    init(
         type: RecordType,
         date: Date,
         notes: String,
         attachedFiles: [String] = [],
         doctor: Doctor? = nil,
         tag: Tag? = nil,
         bodyParts: [String] = [],
         medicine: String = "",
         medicineStartDate: Date? = nil,
         medicineEndDate: Date? = nil
    ) {
         self.type = type
         self.date = date
         self.notes = notes
         self.attachedFiles = attachedFiles
         self.doctor = doctor
         self.tag = tag
         self.bodyParts = bodyParts
         self.medicine = medicine
         self.medicineStartDate = medicineStartDate
         self.medicineEndDate = medicineEndDate
    }
}

@Model
final class Doctor: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var lastVisit: Date

    init(id: UUID = UUID(), name: String, lastVisit: Date) {
        self.id = id
        self.name = name
        self.lastVisit = lastVisit
    }

    enum CodingKeys: String, CodingKey {
        case id, name, lastVisit
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init(name: "", lastVisit: Date())
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.lastVisit = try container.decode(Date.self, forKey: .lastVisit)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(lastVisit, forKey: .lastVisit)
    }
    
    static func == (lhs: Doctor, rhs: Doctor) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Model
final class Tag: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var name: String
    var colorHex: String  // e.g. "#FF0000"
    
    init(name: String, colorHex: String) {
        self.name = name
        self.colorHex = colorHex
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, colorHex
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(colorHex, forKey: .colorHex)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let colorHex = try container.decode(String.self, forKey: .colorHex)
        self.init(name: name, colorHex: colorHex)
        self.id = id
    }
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum RecordType: String, Codable, CaseIterable, Identifiable {
    case doctorVisit = "Doctor Visit"
    case labResult = "Lab Result"
    case radiationResult = "Radiation Result"
    case physicalTherapy = "العلاج الطبيعي"
    
    var id: String { self.rawValue }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
