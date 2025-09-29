import Foundation

protocol AuthRepository {
    func signUp(email: String, password: String, name: String) async throws -> String
    func signIn(email: String, password: String) async throws
    func signOut() async throws
    func forgotPassword(email: String) async throws
    func fetchUser(uid: String) async throws -> AppUser?
}

final class DefaultAuthRepository: AuthRepository {
    private let service = FirebaseAuthService()

    func signUp(email: String, password: String, name: String) async throws -> String {
        try await service.signUp(email: email, password: password, name: name)
    }

    func signIn(email: String, password: String) async throws {
        try await service.signIn(email: email, password: password)
    }

    func signOut() async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try service.signOut()
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func forgotPassword(email: String) async throws {
        try await service.forgotPassword(email: email)
    }

    func fetchUser(uid: String) async throws -> AppUser? {
        try await service.fetchUserDocument(uid: uid)
    }
}
