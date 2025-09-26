//
//  AuthRepository.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import Foundation

//
protocol AuthRepository {
    //
    func signUp(email: String, password: String, name: String) async
    throws -> String
    func signIn(email: String, password: String) async throws
    func signOut() async throws
    func forgotPassword(email: String) async throws
}

//
class DefaultAuthRepository: AuthRepository {
    //
    private let authService = FirebaseAuthService()
    
    //
    func signUp(email: String, password: String, name: String) async throws -> String {
        //
        return try await withCheckedThrowingContinuation {continuation in authService.signUp(email: email, password: password, name: name) {result in switch result {
        case .success(let uid):
            continuation.resume(returning: uid)
        case .failure(let error):
            continuation.resume(throwing: error)
        }
     }
  }
}
    
    //
    func signIn(email: String, password: String) async throws {
        return try await withCheckedThrowingContinuation {
            continuation in authService.signIn(email: email, password: password) {
                result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    //
    func signOut() async throws {
        try authService.signOut()
    }
    
    //
    func forgotPassword(email: String) async throws {
        return try await withCheckedThrowingContinuation{continuation in authService.forgotPassword(email: email){result in
            switch result {
            case .success:
                continuation.resume()
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
}
        
    
    
}
    

