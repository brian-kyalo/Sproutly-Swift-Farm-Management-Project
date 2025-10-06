import SwiftUI

struct AppNavigation: View {
    // MARK: - Properties
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var path = NavigationPath()
    @State private var isSidebarPresented = false
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false

    // MARK: - Auth-based View Logic
    @ViewBuilder
    var navigationContent: some View {
        switch authViewModel.authState {
        case .unknown:
            VStack {
                ProgressView()
                Text("Loading...")
            }

        case .authenticated:
            TabView {
                // MARK: - Home Tab
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }

                // MARK: - Stats Tab
                StatsView()
                    .tabItem { Label("Stats", systemImage: "chart.bar") }

                // MARK: - News Tab
                NewsView()
                    .tabItem { Label("News", systemImage: "newspaper") }
            }
            // MARK: - Navigation Bar + Sidebar
            .navigationTitle("Kilimo Gold")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isSidebarPresented = true
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $isSidebarPresented) {
                SidebarView(isPresented: $isSidebarPresented)
                    .environmentObject(authViewModel)
            }

        case .unauthenticated:
            if !hasSeenIntro {
                IntroView(path: $path, hasSeenIntro: $hasSeenIntro)
            } else {
                LoginView(path: $path)
            }
        }
    }

    // MARK: - Main Body
    var body: some View {
        NavigationStack(path: $path) {
            navigationContent
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

// MARK: - Sidebar View
struct SidebarView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var isPresented: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // MARK: - Header
            HStack {
                Text("Menu")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            // MARK: - Logout Button
            Button(action: {
                Task {
                    await authViewModel.signOut()
                    isPresented = false
                }
            }) {
                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(.vertical, 8)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
