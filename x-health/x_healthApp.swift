//
//  x_healthApp.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

import SwiftUI



@main
struct x_healthAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [MedicalRecord.self, Doctor.self, Tag.self])
    }
}
