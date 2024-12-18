//
//  CustomButtons.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/4/24.
//

import SwiftUI

struct CustomButtons: View {
    var cameraAction: () -> Void
    var galleryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16){
            HStack(spacing: 16) {
                Button(action: cameraAction) {
                    ZStack{
                        Rectangle()
                            .fill(.white)
                            .frame(width: 160, height: 100)
                            .cornerRadius(20)
                        VStack{
                            Image("ScannerButton")
                                .resizable()
                                .frame(width: 27, height: 24)
                            Text("Scanner")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.customBlue)
                        }
                    }
                }
                Button(action: galleryAction) {
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 160, height: 100)
                            .cornerRadius(20)
                        VStack {
                            Image("GalleryButton")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Gallery")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.customBlue)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 120)
    }
}

struct CustomButtonsWrapper: View {
    @State private var scannedImages: [UIImage] = []

    var cameraAction: () -> Void
    var galleryAction: () -> Void

    var body: some View {
        VStack {
            CustomButtons(
                cameraAction: cameraAction,
                galleryAction: galleryAction)

            if !scannedImages.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(scannedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 150)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

