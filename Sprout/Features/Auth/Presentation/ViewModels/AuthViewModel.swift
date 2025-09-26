//
//  AuthViewModel.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import Foundation
import FirebaseAuth

@MainActor //
class AuthViewModel: ObservableObject {
    //
    @Published var user: User?
    @Published var errorMessage: String?
    
    //
    private let signUpUseCase: SignUpUseCase
    private let signInUseCase: SignInUseCase
    private let signOutUseCase: SignOutUseCase
    private let forgotPasswordUseCase: ForgotPasswordUseCase
    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    
    init(signUpUseCase: SignUpUseCase, signInUseCase: SignInUseCase, signOutUseCase: SignOutUseCase, forgotPasswordUseCase: ForgotPasswordUseCase) {
        //
        self.signUpUseCase = signUpUseCase
        self.signInUseCase = signInUseCase
        self.signOutUseCase = signOutUseCase
        self.forgotPasswordUseCase = forgotPasswordUseCase
        setupAuthListener()
    }
    
    //
    private func setupAuthListener() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user.map { User(id: $0.uid, name: "", email: $0.email ?? "") }
        }
    }

    deinit {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    //
    func signUp(email: String, password: String, name: String) async {
           do {
               _ = try await signUpUseCase.execute(email: email, password: password, name: name) // Ignore return value
               errorMessage = nil
           } catch {
               errorMessage = error.localizedDescription
           }
       }
    
    func signIn(email: String, password: String) async {
            do {
                try await signInUseCase.execute(email: email, password: password)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        func signOut() async {
            do {
                try await signOutUseCase.execute()
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        func forgotPassword(email: String) async {
            do {
                try await forgotPasswordUseCase.execute(email: email)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    
}
