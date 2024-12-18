//
//  OnboardingViewModel.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/4/24.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    enum ViewState {
        case welcome
        case home
    }
    
    @Published private(set) var currentView: ViewState
    @Published var currentOnboardingStep: OnboardingEnumStates
    
    init() {
        self.currentView = UserDefaults.standard.bool(forKey: "hasSeenOnboarding") ? .home : .welcome
        self.currentOnboardingStep = .firstOnboardingState
    }
    
    func completeOnboarding() {
        currentView = .home
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    }
}
