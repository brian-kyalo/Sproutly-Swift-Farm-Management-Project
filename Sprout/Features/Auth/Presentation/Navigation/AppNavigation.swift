import SwiftUI

struct AppNavigation: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var path = NavigationPath()
    
    // Track if intro has been seen
    @State private var hasSeenIntro = false
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if let _ = authViewModel.currentUser {
                    // Logged in → straight to Home
                    HomeView()
                } else if !hasSeenIntro {
                    // First time (or until user signs in/up) → Intro
                    IntroView(path: $path, hasSeenIntro: $hasSeenIntro)
                } else {
                    // After intro → default to Login/Register flow
                    LoginView(path: $path)
                }
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "login":
                    LoginView(path: $path)
                case "register":
                    RegisterView(path: $path)
                default:
                    EmptyView()
                }
            }
        }
    }
}
