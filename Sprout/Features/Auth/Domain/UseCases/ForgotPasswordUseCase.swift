//
//  ForgotPasswordUseCase.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import Foundation

class ForgotPasswordUseCase{
    //
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    //
    func execute(email: String) async throws {
        try await authRepository.forgotPassword(email: email)
    }
}
