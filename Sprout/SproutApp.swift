import SwiftUI
import FirebaseCore

@main
struct SproutApp: App {
    @StateObject private var authViewModel: AuthViewModel

    init() {
        //
        FirebaseApp.configure()

        // single repository + service
        let authRepository = DefaultAuthRepository()
        let authUseCases = AuthUseCases(repository: authRepository)

        _authViewModel = StateObject(wrappedValue: AuthViewModel(useCases: authUseCases))
    }

    var body: some Scene {
        WindowGroup {
            AppNavigation()
                .environmentObject(authViewModel) // Provides env object for the entire app.
        }
    }
}
