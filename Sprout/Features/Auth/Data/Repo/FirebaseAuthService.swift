import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseAuthService {
    // Register
    func signUp(email: String, password: String, name: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: error); return
                }
                guard let uid = authResult?.user.uid else {
                    continuation.resume(throwing: NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing UID"]))
                    return
                }
                // Save profile document
                let data: [String: Any] = ["name": name, "email": email]
                Firestore.firestore().collection("users").document(uid).setData(data) { err in
                    if let err = err { continuation.resume(throwing: err) } else { continuation.resume(returning: uid) }
                }
            }
        }
    }

    // Login
    func signIn(email: String, password: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    // Sign out (synchronous)
    func signOut() throws {
        try Auth.auth().signOut()
    }

    // FORGOT -> Void
        func forgotPassword(email: String) async throws {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            }
        }

    //
    func fetchUserDocument(uid: String) async throws -> AppUser? {
        try await withCheckedThrowingContinuation { continuation in
            Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
                if let error = error { continuation.resume(throwing: error); return }
                guard let data = snapshot?.data() else { continuation.resume(returning: nil); return }
                let name = data["name"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                continuation.resume(returning: AppUser(id: uid, name: name, email: email))
            }
        }
    }
}
