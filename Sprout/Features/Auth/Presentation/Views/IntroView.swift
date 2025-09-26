//
//  IntroView.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import SwiftUI

struct IntroView: View {
    @Binding var path: NavigationPath

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Sproutly")
                .font(.largeTitle)
            Button("Login") {
                path.append("login")
            }
            .buttonStyle(.borderedProminent)
            Button("Register") {
                path.append("register")
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
