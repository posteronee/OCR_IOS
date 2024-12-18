//
//  ImagePicker.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/5/24.
//

import SwiftUI
import PhotosUI

struct PHImagePicker: UIViewControllerRepresentable {
    let configuration: PHPickerConfiguration
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selectedImage: [UIImage]
    var itemProviders: [NSItemProvider] = []
    let group = DispatchGroup()
    var asyncDict = [String:UIImage]()
    var order = [String]()
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = configuration
        config.filter = .images
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        var images = [UIImage]()

        private var parent: PHImagePicker
        
        init(_ parent: PHImagePicker) {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            for result in results {
                self.parent.order.append(result.assetIdentifier ?? "")
                self.parent.group.enter()
                let provider = result.itemProvider
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { image, _ in
                        guard let updatedImage = image as? UIImage else { self.parent.group.leave();return }
                        self.parent.asyncDict[result.assetIdentifier ?? ""] = updatedImage
                        self.parent.group.leave()
                    }
                } else {
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
            self.parent.group.notify(queue: .main) {
                for id in self.parent.order {
                    self.parent.selectedImage.append(self.parent.asyncDict[id]!)
                }
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
