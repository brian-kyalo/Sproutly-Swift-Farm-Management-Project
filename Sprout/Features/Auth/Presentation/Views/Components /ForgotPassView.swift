//
//  ForgotPassView.swift
//  Sprout
//
//  Created by Student1 on 06/10/2025.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var isLoading = false
    @State private var successMessage: String? // Added for success feedback

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Reset Password")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("Enter your email to receive a password reset link.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                if let success = successMessage {
                    Text(success)
                        .foregroundColor(.green)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button {
                    Task {
                        isLoading = true
                        authViewModel.errorMessage = nil // Clear previous errors
                        await authViewModel.forgotPassword(email: email)
                        isLoading = false
                        if authViewModel.errorMessage == nil {
                            successMessage = "Reset link sent! Check your email."
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                dismiss() // Auto-dismiss after 2 seconds
                            }
                        }
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    } else {
                        Text("Send Reset Link")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                }
                .background(email.isEmpty ? Color.gray : Color.blue)
                .cornerRadius(12)
                .disabled(email.isEmpty)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
}
