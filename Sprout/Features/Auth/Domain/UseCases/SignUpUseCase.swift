//
//  SignUpUseCase.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import Foundation

//
class SignUpUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    //
    func execute(email: String, password: String, name: String) async throws -> String{
        
        //
        return try await authRepository.signUp(email: email, password: password, name: name)
        
    }
}
