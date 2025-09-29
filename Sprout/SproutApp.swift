import SwiftUI
import FirebaseCore

@main
struct SproutApp: App {
    @StateObject private var authViewModel: AuthViewModel

    init() {
        FirebaseApp.configure()

        // single repository + service
        let authRepository = DefaultAuthRepository()
        let useCases = AuthUseCases(repository: authRepository)

        _authViewModel = StateObject(wrappedValue: AuthViewModel(useCases: useCases))
    }

    var body: some Scene {
        WindowGroup {
            AppNavigation()
                .environmentObject(authViewModel) // provide environment object for entire app
        }
    }
}
