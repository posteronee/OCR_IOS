//
//  ViewExtension.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/4/24.
//

import Foundation
import SwiftUI

extension View {
    func modalButtons<Content:View>(
        _ isPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ZStack(alignment: .bottom) {
            self
            if isPresented.wrappedValue {
                Rectangle()
                    .fill(.black)
                    .opacity(0.3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented.wrappedValue = false
                    }
                content()
                    
            }
        }
        .animation(.bouncy, value: isPresented.wrappedValue)
    }
    
    func halfSheet<SheetView: View>(
        showSheet: Binding<Bool>,
        close: Binding<Bool>,
        @ViewBuilder sheetView: @escaping () -> SheetView
    ) -> some View {
        return background {
            HalfSheetHelper(showSheet: showSheet,
                            close: close,
                            sheetView: sheetView())
            
        }
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    @Binding var showSheet: Bool
    @Binding var close: Bool
    var sheetView: SheetView

    let controller = UIViewController()

    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController,
                                context: Context) {
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            uiViewController.present(sheetController, animated: true) {
                DispatchQueue.main.async {
                    self.showSheet.toggle()
                    self.close = false
                }
            }
        }
        if close {
            uiViewController.dismiss(animated: true) {
                DispatchQueue.main.async {
                    self.close.toggle()
                    self.showSheet = false
                }
            }
        }
    }
}

final class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        if let presentationController = presentationController as?
            UISheetPresentationController
        {
            presentationController.detents = [
                .medium()
            ]
            presentationController.prefersGrabberVisible = true
        }
    }
}
