//
//  Onboarding.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/4/24.
//

import SwiftUI

struct Onboarding: View {
    @ObservedObject var vm: OnboardingViewModel
    
    var greetingView: ViewComponents {
        .init(type: .firstOnboardingState, background: "OnboardingImage", mainText: "Handwriting Recognizer", additionalText: "Some words about app \nbla bla bla", buttonText: "Continue", action: {
            vm.currentOnboardingStep = .secondOnboardingState
        })
    }
    
    var recallView: ViewComponents {
        .init(type: .secondOnboardingState, background: "OnboardingImage", mainText: "", additionalText: "", buttonText: "Continue", action: {
            vm.currentOnboardingStep = .thirdOnboardingState
            
        })
    }
    
    var appFacilitiesView: ViewComponents {
        .init(type: .thirdOnboardingState, background: "OnboardingImage", mainText: "", additionalText: "", buttonText: "Continue", action: {
            vm.completeOnboarding()
        })
    }
    
    var currentState: ViewComponents {
        switch vm.currentOnboardingStep {
        case .firstOnboardingState:
            return greetingView
        case .secondOnboardingState:
            return recallView
        case .thirdOnboardingState:
            return appFacilitiesView
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.white
                    .edgesIgnoringSafeArea(.all)

                VStack{
                    BodyView(vm: vm, data: currentState)
                }
            }
        }
    }
}
