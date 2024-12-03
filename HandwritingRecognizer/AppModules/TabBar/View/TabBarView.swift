//
//  TabBarView.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/4/24.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedTab = 0
    @State private var isButtonsPresented = false
    @State private var showCamera = false
    @State private var isShowingPhotoPicker = false
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                getCurrentView()
                Spacer()
                CustomTabBar(selectedTab: $selectedTab, isButtonsPresented: $isButtonsPresented)
                    .padding(.horizontal, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .modalButtons($isButtonsPresented) {
                CustomButtonsWrapper(
                    cameraAction: {
                        showCamera = true
                    },
                    galleryAction: {
                        showAlert = true
                        //                        switch imageViewModel.libraryAccess {
                        //                        case .authorized, .limited:
                        //                            isShowingPhotoPicker.toggle()
                        //                        default:
                        //                            showAlert = true
                        //                        }
                    }
                )
            }
        }
    }

    @ViewBuilder
    private func getCurrentView() -> some View {
        switch selectedTab {
        case 0:
            DocumentsView()
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
