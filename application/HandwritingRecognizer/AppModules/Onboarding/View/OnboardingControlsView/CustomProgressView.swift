//
//  CustomProgressView.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/4/24.
//

import SwiftUI

struct CustomProgressView: View {
    var currentStep: Int
    var totalSteps: Int = 3

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...totalSteps, id: \.self) { step in
                if step == currentStep {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.blue)
                        .frame(width: 32, height: 8)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
            }
        }
    }
}
