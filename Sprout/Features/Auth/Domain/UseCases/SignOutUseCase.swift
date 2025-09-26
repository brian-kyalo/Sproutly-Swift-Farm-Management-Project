//
//  SignOutUseCase.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import Foundation

class SignOutUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute() async throws {
        try await authRepository.signOut()
    }
}
