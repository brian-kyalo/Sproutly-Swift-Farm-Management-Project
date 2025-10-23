//
//  SidebarView.swift
//  Sprout
//
//  Created by Student1 on 23/10/2025.
//

import Foundation
import SwiftUI

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
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top, 50)

            Divider()

            Button(action: {
                Task {
                    await authViewModel.signOut()
                    withAnimation {
                        isPresented = false
                    }
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: UIScreen.main.bounds.width * 0.75)
        .background(.ultraThinMaterial) // crystal see-through background
        .edgesIgnoringSafeArea(.all)
        .shadow(radius: 10)
    }
}
