//
//  body.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/4/24.
//

import SwiftUI
import StoreKit

struct BodyView: View {
    @ObservedObject var vm: OnboardingViewModel
    @State var topRight: CGFloat = 60
    let data: ViewComponents

    var body: some View {
        ZStack {
            Image(data.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer()
                
                ZStack {
                    Rectangle()
                        
                        .fill(.white)
                        .cornerRadius(topRight, corners: [.topRight])
                        .edgesIgnoringSafeArea(.all)
                        
                        .frame(height: 300)
                        .shadow(radius: 10)

                    VStack {
                        VStack{
                            Text(data.mainText)
                                .font(.system(size: 24, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                        }.frame(height: 67)
                        
                        VStack{
                        Text(data.additionalText)
                                .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)
                        }.frame(height: 60)
                        
                        VStack(spacing: 20){
                            CustomProgressView(currentStep: getStep(from: vm.currentOnboardingStep))
                            
                            CustomButton(action: data.action, buttonText: data.buttonText)

                        }.frame(height: 138)
                    }
                }
            }
            .padding(.bottom)
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: vm.currentOnboardingStep) { newState in
            if newState == .thirdOnboardingState {
                requestAction()
            }
        }
    }

    private func getStep(from state: OnboardingEnumStates) -> Int {
        switch state {
        case .firstOnboardingState: return 1
        case .secondOnboardingState: return 2
        case .thirdOnboardingState: return 3
        }
    }

    private func requestAction() {
        Task { @MainActor in
            if let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive })
                as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}
