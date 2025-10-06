// Features/Auth/Presentation/AuthViewModel.swift
import Foundation
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
    //
    @Published var authState: AuthState = .unknown
    @Published var errorMessage: String?

    private let useCases: AuthUseCases
    private var handle: AuthStateDidChangeListenerHandle?

    enum AuthState: Equatable {
        case unknown
        case authenticated(AppUser)
        case unauthenticated
    }

    init(useCases: AuthUseCases) {
        self.useCases = useCases
        setupAuthListener()
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    private func setupAuthListener() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            Task { @MainActor in
                guard let self = self else { return }
                if let fbUser = firebaseUser {
                    // try to fetch fuller profile from Firestore
                    do {
                        let appUser = try await self.useCases.fetchUser(uid: fbUser.uid) ?? AppUser(id: fbUser.uid, name: fbUser.displayName ?? "", email: fbUser.email ?? "")
                        self.authState = .authenticated(appUser)
                    } catch {
                        // fallback to minimal user
                        self.authState = .authenticated(AppUser(id: fbUser.uid, name: fbUser.displayName ?? "", email: fbUser.email ?? ""))
                    }
                } else {
                    self.authState = .unauthenticated
                }
            }
        }
    }

    //
    func signUp(email: String, password: String, name: String) async {
        do {
            _ = try await useCases.signUp(email: email, password: password, name: name)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    //
    func signIn(email: String, password: String) async {
        do {
            try await useCases.signIn(email: email, password: password)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    //
    func signOut() async {
        do {
            try await useCases.signOut()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    //
    func forgotPassword(email: String) async {
        do {
            try await useCases.forgotPassword(email: email)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
