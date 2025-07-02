//
//  HomeView.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

import Foundation
// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.xHealthBackground.edgesIgnoringSafeArea(.all)
            VStack(spacing: 40) {
                LogoView()
                    .padding(.top, 60)
                Spacer()
                VStack(spacing: 20) {
                    NavigationLink(destination: AllHistoryView()) {
                        HomeButton(title: "All History", subtitle: "View records")
                    }
                    NavigationLink(destination: AddUpdateRecordView()) {
                        HomeButton(title: "Add/Update Record", subtitle: "Create a new record")
                    }
                    NavigationLink(destination: AddDoctorView()) {
                        HomeButton(title: "Add Doctor", subtitle: "New doctor info")
                    }
                    NavigationLink(destination: AddTagView()) {
                        HomeButton(title: "Add Tag", subtitle: "New tag and color")
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
            }
        }
    }
}
