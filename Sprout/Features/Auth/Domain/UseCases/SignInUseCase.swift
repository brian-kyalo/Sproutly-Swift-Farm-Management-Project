//
//  SignInUseCase.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import Foundation

//
class SignInUseCase {
    //
    private let authRepository: AuthRepository
    
    //
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    //
    func execute(email: String, password: String) async throws {
        try await authRepository.signIn(email: email, password: password)
    }
}
