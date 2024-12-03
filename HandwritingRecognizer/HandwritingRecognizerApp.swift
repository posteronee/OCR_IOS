//
//  HandwritingRecognizerApp.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/4/24.
//

import SwiftUI

@main
struct HandwritingRecognizerApp: App {
    var body: some Scene {
        WindowGroup {
            AppEntryPoint(content: ContentView())
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("App")
                .foregroundStyle(.black)
        }
    }
}
