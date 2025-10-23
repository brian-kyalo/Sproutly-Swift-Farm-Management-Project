/**
 *  The Navigation Structure - used in my App to manage which part of the app to display based on wether the user is Authenticated or not.
 *   SwiftUI is apple's declarative UI framework (you actually declare how a view looks appear)
 */

import SwiftUI

struct AppNavigation: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    var isDark: Bool { colorScheme == .dark }

    @State private var path = NavigationPath()
    @State private var isSidebarPresented = false
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .leading) {
                navigationContent
                    .blur(radius: isSidebarPresented ? 3 : 0)
                    .disabled(isSidebarPresented)
                    .animation(.easeInOut(duration: 0.25), value: isSidebarPresented)

                if isSidebarPresented {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isSidebarPresented = false
                            }
                        }
                }

                SidebarView(isPresented: $isSidebarPresented)
                    .environmentObject(authViewModel)
                    .frame(width: UIScreen.main.bounds.width * 0.75)
                    .offset(x: isSidebarPresented ? 0 : -UIScreen.main.bounds.width * 0.75)
                    .animation(.easeInOut(duration: 0.25), value: isSidebarPresented)
            }

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            isSidebarPresented.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(isDark ? .white : .black)
                    }
                }
                
                
//                //
//                ToolbarItem(placement: .principal) {
//                    Image(.applogo)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 65, height: 65)
//                }
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "login": LoginView(path: $path)
                case "register": RegisterView(path: $path)
                case "tasks": TasksView()
                case "inventory": InventoryView()
                default: EmptyView()
                }
            }
        }
    }

    @ViewBuilder
    var navigationContent: some View {
        switch authViewModel.authState {
        case .unknown:
            ProgressView("Loading...")

        case .authenticated:
            TabView {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }
                StatsView()
                    .tabItem { Label("Stats", systemImage: "chart.bar") }
                NewsView()
                    .tabItem { Label("News", systemImage: "newspaper") }
            }
            .tint(isDark ? .white : .black)

        case .unauthenticated:
            if !hasSeenIntro {
                IntroView(path: $path, hasSeenIntro: $hasSeenIntro)
            } else {
                LoginView(path: $path)
            }
        }
    }
}
