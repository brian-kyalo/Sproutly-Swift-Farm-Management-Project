//
//  LoginView.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import SwiftUI

struct LoginView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPassword = false
    @State private var forgotEmail = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            Button("Forgot Password?") {
                showForgotPassword = true
            }
            .font(.footnote)
            if let error = authViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            Button("Login") {
                Task {
                    await authViewModel.signIn(email: email, password: password)
                    // Success handled by auth listener
                }
            }
            .buttonStyle(.borderedProminent)
            HStack {
                Text("Don't have an account?")
                Button("Register") {
                    path.removeLast()
                    path.append("register")
                }
            }
        }
        .padding()
        .navigationTitle("Login")
        .alert("Forgot Password", isPresented: $showForgotPassword) {
            TextField("Email", text: $forgotEmail)
                .keyboardType(.emailAddress)
            Button("Send Reset Link") {
                Task {
                    await authViewModel.forgotPassword(email: forgotEmail)
                    showForgotPassword = false
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
