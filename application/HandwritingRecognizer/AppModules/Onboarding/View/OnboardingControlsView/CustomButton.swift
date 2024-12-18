//
//  CustomButton.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/4/24.
//

import SwiftUI

struct CustomButton: View {
    var action: () -> Void
    var buttonText: String
    
    var body: some View {
        Button(action: action) {
            Text(buttonText)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 240, height: 50)
                .background(.customBlue)
                .cornerRadius(100)
        }
        .frame(maxWidth: .infinity)
    }
}
