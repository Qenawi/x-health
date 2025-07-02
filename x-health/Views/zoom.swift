//
//  zoom.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

import SwiftUI



struct ZoomableImageView: View {
    var imageFileName: String
    @Environment(\.dismiss) var dismiss

    /// Loads an image from the Documents directory given a filename.
    private func loadImage() -> UIImage? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = documentsURL.appendingPathComponent(imageFileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    var body: some View {
        Group {
            if let uiImage = loadImage() {
                ZStack(alignment: .topTrailing) {
                    ZoomableScrollView {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black)
                    }
                    .ignoresSafeArea()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .padding()
                            .foregroundColor(.white)
                    }
                }
            } else {
                Text("Image not found")
                    .foregroundColor(.white)
                    .background(Color.black)
            }
        }
    }
}

struct ZoomableImageView_Previews: PreviewProvider {
    static var previews: some View {
        ZoomableImageView(imageFileName: "sampleImage.jpg")
            .preferredColorScheme(.dark)
    }
}


struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIView(context: Context) -> UIScrollView {
        // Create a UIScrollView and set up zooming.
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        // Create a UIHostingController that hosts our SwiftUI content.
        let hostedView = context.coordinator.hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = true
        hostedView.frame = scrollView.bounds
        hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.addSubview(hostedView)
        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // Update the hosted SwiftUI view.
        context.coordinator.hostingController.rootView = content
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(content: content)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>

        init(content: Content) {
            hostingController = UIHostingController(rootView: content)
            hostingController.view.backgroundColor = .clear
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController.view
        }
    }
}
