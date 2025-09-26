//
//  SproutApp.swift
//  Sprout
//
//  Created by Student1 on 24/09/2025.
//

import SwiftUI
import FirebaseCore

@main
struct SproutApp: App {
    //
    @StateObject private var authViewModel: AuthViewModel
    
    //
    private let authRepository = DefaultAuthRepository()
    
    // initialize firebase to Sproutly.
    init() {
            FirebaseApp.configure()
            let signUpUseCase = SignUpUseCase(authRepository: authRepository)
            let signInUseCase = SignInUseCase(authRepository: authRepository)
            let signOutUseCase = SignOutUseCase(authRepository: authRepository)
            let forgotPasswordUseCase = ForgotPasswordUseCase(authRepository: authRepository)
            _authViewModel = StateObject(wrappedValue: AuthViewModel(
                signUpUseCase: signUpUseCase,
                signInUseCase: signInUseCase,
                signOutUseCase: signOutUseCase,
                forgotPasswordUseCase: forgotPasswordUseCase
            ))
        }
    
    
    var body: some Scene {
        WindowGroup {
            AppNavigation()
                .environmentObject(authViewModel)
        }
    }
}
