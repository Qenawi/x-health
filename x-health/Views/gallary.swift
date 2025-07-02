//
//  gallary.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

import SwiftUI

struct ImageGalleryView: View {
    var imageFileNames: [String]
    @Binding var selectedIndex: Int
    @Environment(\.dismiss) var dismiss

    /// Loads an image from the Documents directory given its filename.
    private func loadImage(from file: String) -> UIImage? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = documentsURL.appendingPathComponent(file)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $selectedIndex) {
                ForEach(imageFileNames.indices, id: \.self) { index in
                    if let uiImage = loadImage(from: imageFileNames[index]) {
                        // Wrap the image in ZoomableScrollView for zoom support.
                        ZoomableScrollView {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .tag(index)
                        .ignoresSafeArea()
                    } else {
                        Color.black.tag(index)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.white)
            }
        }
    }
}

struct ImageGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        // For preview purposes, replace with valid sample image file names if available.
        ImageGalleryView(imageFileNames: ["sampleImage1.jpg", "sampleImage2.jpg"], selectedIndex: .constant(0))
            .preferredColorScheme(.dark)
    }
}
