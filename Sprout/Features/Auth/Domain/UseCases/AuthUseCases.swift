//
//  AuthUseCases.swift
//  Sprout
//
//  Created by Student1 on 29/09/2025.
//

import Foundation


struct AuthUseCases {
    let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func signUp(email: String, password: String, name: String) async throws -> String {
        try await repository.signUp(email: email, password: password, name: name)
    }

    func signIn(email: String, password: String) async throws {
        try await repository.signIn(email: email, password: password)
    }

    func signOut() async throws {
        try await repository.signOut()
    }

    func forgotPassword(email: String) async throws {
        try await repository.forgotPassword(email: email)
    }

    func fetchUser(uid: String) async throws -> AppUser? {
        try await repository.fetchUser(uid: uid)
    }
}
