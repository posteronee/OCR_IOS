//
//  GalleryConfigViewModel.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/5/24.
//

import PhotosUI

class GalleryConfigViewModel: ObservableObject {
    @Published var imagePickerPresented: Bool = false
    @Published var libraryAccess = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    @Published var selectedImages: [UIImage] = []

    var setupConfig: PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = 10
        config.filter = .images
        return config
    }

    func checkLibraryAccess() {
        let photos = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.libraryAccess = status
                }
            }
        } else {
            DispatchQueue.main.async {
                self.libraryAccess = photos
            }
        }
    }
}
