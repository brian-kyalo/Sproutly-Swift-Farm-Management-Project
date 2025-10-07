import SwiftUI

struct AppNavigation: View {
    //
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var path = NavigationPath()
    @State private var isSidebarPresented = false
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false

    //
    @ViewBuilder
    var navigationContent: some View {
        switch authViewModel.authState {
        //
        case .unknown:
            VStack {
                ProgressView()
                Text("Loading...")
            }
            
        //
        case .authenticated:
            TabView {
                //
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }

                //
                StatsView()
                    .tabItem { Label("Stats", systemImage: "chart.bar") }

                //
                NewsView()
                    .tabItem { Label("News", systemImage: "newspaper") }
            }
            
            //
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
            
        //
        case .unauthenticated:
            if !hasSeenIntro {
                IntroView(path: $path, hasSeenIntro: $hasSeenIntro)
            } else {
                LoginView(path: $path)
            }
        }
    }
    
    
    //
    var body: some View {
        NavigationStack(path: $path) {
            navigationContent
                .navigationDestination(for: String.self) { destination in
                    switch destination {
                    case "login":
                        LoginView(path: $path)
                    case "register":
                        RegisterView(path: $path)
                        
                    case "tasks":
                        TasksView()
                    case "inventory":
                        InventoryView()
                    default:
                        EmptyView()
                    }
                }
        }
    }
}

//
struct SidebarView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var isPresented: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
