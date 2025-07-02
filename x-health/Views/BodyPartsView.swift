//
//  BodyPartsView.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

import Foundation
// Views/BodyPartsView.swift
import SwiftUI

struct BodyPartsView: View {
    let bodyParts = ["Left Knee", "Right Knee", "Left Elbow", "Right Elbow", "Left Shoulder", "Right Shoulder", "Lower Back", "Neck"]
    
    var body: some View {
        ZStack {
            Color.xHealthBackground.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Body Parts")
                    .font(.largeTitle)
                    .foregroundColor(.xHealthPrimaryText)
                    .padding()
                List(bodyParts, id: \.self) { part in
                    HStack {
                        Image(systemName: "heart.text.square")
                            .foregroundColor(.xHealthAccent)
                        Text(part)
                            .foregroundColor(.xHealthPrimaryText)
                    }
                    .listRowBackground(Color.xHealthBackground)
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
    }
}
