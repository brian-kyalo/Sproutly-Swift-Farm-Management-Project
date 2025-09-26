//
//  HomeView.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var currentView: MainView = .home
    @State private var showingProfile = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main content
                VStack(spacing: 20) {
                    Text("Welcome to the Homepage")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("This is your main dashboard")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // You can add more home content here
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        // Menu items
                        Button(action: {
                            showingProfile = true
                        }) {
                            Label("Profile", systemImage: "person.circle")
                        }
                        
                        Button(action: {
                            showingSettings = true
                        }) {
                            Label("Settings", systemImage: "gear")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive, action: {
                            Task {
                                await authViewModel.signOut()
                            }
                        }) {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                        
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                    }
                }
            }
        }
        // Sheet presentations for other views
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

enum MainView {
    case home, profile, settings
}

// Profile View
struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("User profile information goes here")
                    .foregroundColor(.secondary)
                
                // Add profile content here
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Settings View
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("App settings and preferences")
                    .foregroundColor(.secondary)
                
                // Add settings content here
                
                Spacer()
            }
            .padding()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
