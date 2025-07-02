//
//  DoctorsView.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

import Foundation
// Views/DoctorsView.swift
import SwiftUI

struct DoctorsView: View {
    // Sample doctor data.
    let doctors: [Doctor] = [
        Doctor(id: UUID(), name: "Dr. Smith", lastVisit: Date()),
        Doctor(id: UUID(), name: "Dr. Johnson", lastVisit: Calendar.current.date(byAdding: .day, value: -30, to: Date())!)
    ]
    
    var body: some View {
        ZStack {
            Color.xHealthBackground.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Doctors")
                    .font(.largeTitle)
                    .foregroundColor(.xHealthPrimaryText)
                    .padding()
                List(doctors) { doctor in
                    HStack {
                        Text(doctor.name)
                            .foregroundColor(.xHealthPrimaryText)
                        Spacer()
                        Text("Last: \(doctor.lastVisit, formatter: dateFormatter)")
                            .foregroundColor(.xHealthSecondaryText)
                    }
                    .listRowBackground(Color.xHealthBackground)
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
    }
}

