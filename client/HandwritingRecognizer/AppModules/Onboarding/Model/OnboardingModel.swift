//
//  OnboardingModel.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/4/24.
//

import Foundation

struct ViewComponents {
    var type: OnboardingEnumStates
    var background: String
    var mainText: String
    var additionalText: String
    var buttonText: String
    
    var action: () -> Void
}
