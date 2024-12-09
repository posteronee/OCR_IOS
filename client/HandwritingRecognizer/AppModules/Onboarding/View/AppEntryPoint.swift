//
//  AppEntryPoint.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/4/24.
//

import SwiftUI

struct AppEntryPoint<Content>: View where Content : View {
    let content: Content
    @StateObject var vm = OnboardingViewModel()
    
    var body: some View {
        Group {
            switch vm.currentView {
            case .welcome:
                Onboarding(vm: vm)
            case .home:
                content
            }
        }
    }
}
