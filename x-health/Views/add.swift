//
//  add.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

// Views/AddDoctorView.swift
import SwiftUI
import SwiftData

struct AddDoctorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var lastVisit: Date = Date()
    
    var body: some View {
        Form {
            Section(header: Text("Doctor Details")) {
                TextField("Name", text: $name)
                DatePicker("Last Visit", selection: $lastVisit, displayedComponents: .date)
            }
            Button("Save Doctor") {
                let doctor = Doctor(name: name, lastVisit: lastVisit)
                modelContext.insert(doctor)
                try? modelContext.save()
                dismiss()
            }
        }
        .navigationTitle("Add Doctor")
    }
}

struct AddTagView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var tagName: String = ""
    @State private var selectedColor: Color = .red
    
    var body: some View {
        Form {
            Section(header: Text("Tag Details")) {
                TextField("Tag Name", text: $tagName)
                ColorPicker("Select Tag Color", selection: $selectedColor)
            }
            Button("Save Tag") {
                let hex = selectedColor.toHex() ?? "#FF0000"
                let tag = Tag(name: tagName, colorHex: hex)
                modelContext.insert(tag)
                try? modelContext.save()
                dismiss()
            }
        }
        .navigationTitle("Add Tag")
    }
}
