//
//  AppNavigation.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import SwiftUI

struct AppNavigation: View {
    
    //
    @EnvironmentObject var authViewModel: AuthViewModel
    
    //
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
            if authViewModel.user != nil {
                HomeView()
            } else {
                IntroView(path: $path)
                    .navigationDestination(for: String.self) { destination in
                        if destination == "login" {
                            LoginView(path: $path)
                        } else if destination == "register" {
                            RegisterView(path: $path)
                        }
                    }
            }
        }
    }
}
