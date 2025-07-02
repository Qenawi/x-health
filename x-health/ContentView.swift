//
//  ContentView.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

import SwiftUI


// ContentView.swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}
