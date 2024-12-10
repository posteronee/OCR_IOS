//
//  TabBarView.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/4/24.
//

import SwiftUI
import Foundation
import UIKit

struct TabBar: View {
    @State private var selectedTab = 0
    @State private var scannedImages: [UIImage] = []
    @State private var isButtonsPresented = false
    @State private var showScanner = false
    @State private var isShowingPhotoPicker = false
    @State private var showAlert = false
    @State private var ocrResult: String? = nil
    @State private var showOCRResult = false

    
    @StateObject var galleryConfigViewModel: GalleryConfigViewModel = GalleryConfigViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    getCurrentView()
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab, isButtonsPresented: $isButtonsPresented)
                        .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .modalButtons($isButtonsPresented) {
                CustomButtonsWrapper(
                    cameraAction: {
                        showScanner = true
                    },
                    galleryAction: {
                        showAlert = true
                        switch galleryConfigViewModel.libraryAccess {
                        case .authorized, .limited:
                            isShowingPhotoPicker.toggle()
                        default:
                            showAlert = true
                        }
                    }
                )
            }
            .fullScreenCover(isPresented: $isShowingPhotoPicker) {
                PHImagePicker(configuration: galleryConfigViewModel.setupConfig, selectedImage: $galleryConfigViewModel.selectedImages)
                    .edgesIgnoringSafeArea(.all)
                    .onDisappear {
                        if let image = galleryConfigViewModel.selectedImages.first {
                            uploadImageToServer(image: image) { result in
                                DispatchQueue.main.async {
                                    if let result = result {
                                        ocrResult = result
                                        showOCRResult = true
                                    }
                                }
                            }
                        }
                    }
            }
            .fullScreenCover(isPresented: $showScanner) {
                VNDocumentCameraViewControllerRepresentable(scanResult: $scannedImages)
                    .edgesIgnoringSafeArea(.all)
                    .onDisappear {
                        if let image = scannedImages.first {
                            uploadImageToServer(image: image) { result in
                                DispatchQueue.main.async {
                                    if let result = result {
                                        ocrResult = result
                                        showOCRResult = true
                                    }
                                }
                            }
                        }
                    }
            }
            .sheet(isPresented: $showOCRResult) {
                if let ocrResult = ocrResult {
                    OCRResultView(ocrResult: ocrResult)
                }
            }
            .onAppear {
                galleryConfigViewModel.checkLibraryAccess()
            }
        }
    }
    
    func uploadImageToServer(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "http://srv1.alyukov.net:5000/upload") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = image.jpegData(compressionQuality: 0.8)
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file1\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        if let data = imageData {
            body.append(data)
        }
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            guard let data = data, let responseString = String(data: data, encoding: .utf8), error == nil else {
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            completion(responseString)
        }.resume()
    }
    
    @ViewBuilder
    private func getCurrentView() -> some View {
        switch selectedTab {
        case 0:
//            DocumentsView()
            OCRResultView(ocrResult: "Result")
        case 1:
            SettingsView()
        default:
            EmptyView()
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var isButtonsPresented: Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 200) {
                TabBarItem(icon1: "HomeImage2", icon2: "HomeImage1", isSelected: selectedTab == 0)
                    .onTapGesture {
                        selectedTab = 0
                    }
                
                TabBarItem(icon1: "SettingsImage2", icon2: "SettingsImage1", isSelected: selectedTab == 1)
                    .onTapGesture {
                        selectedTab = 1
                    }
            }
            .frame(height: 70)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(.customGray)
            .clipShape(Capsule())
            
            VStack {
                Button(action: {
                    isButtonsPresented.toggle()
                }) {
                    Image("ScannerImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 64)
                        .padding(10)
                        .clipShape(Circle())
                }
            }
            .background{
                Circle()
                    .fill(.white)
                    .frame(width: 70, height: 70)
            }
            .offset(y: -30)
        }
    }
}

struct TabBarItem: View {
    let icon1: String
    let icon2: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image(isSelected ? icon1 : icon2)
                .resizable()
                .frame(width: 24, height: 24)
        }
        .padding(.vertical, 10)
    }
}

struct DocumentsView: View {
    var body: some View {
        Text("")
            .navigationTitle("Scans")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("")
            .navigationTitle("Settings")
    }
}
