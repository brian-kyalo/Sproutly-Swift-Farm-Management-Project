//
//  RegisterView.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import SwiftUI

struct RegisterView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
            if let error = authViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            Button("Sign Up") {
                Task {
                    if password != confirmPassword {
                        authViewModel.errorMessage = "Passwords do not match"
                        return
                    }
                    await authViewModel.signUp(email: email, password: password, name: name)
                    if authViewModel.errorMessage == nil {
                        path.removeLast()
                        path.append("login")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            HStack {
                Text("Already have an account?")
                Button("Login") {
                    path.removeLast()
                    path.append("login")
                }
            }
        }
        .padding()
        .navigationTitle("Register")
    }
}
