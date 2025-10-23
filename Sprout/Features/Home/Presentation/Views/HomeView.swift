//
//  HomeView.swift
//  Sprout
//
//  Created by Student1 on 06/10/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = HomeViewModel(
        useCases: ProjectUseCases(repository: DefaultProjectRepository())
    )
    
    @Environment(\.colorScheme) var colorScheme
    var isDark: Bool {colorScheme == .dark}
    
    @State private var showAddSheet = false
    @State private var showAmounts = false
    
    var body: some View {
        if case .authenticated(let user) = authViewModel.authState {
            
            //
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    totalsSection
                    iconsSection
                    projectsSection
                }
                .padding()
            }
            .navigationTitle("Home")
            .onAppear {
                viewModel.setupListeners(userId: user.id)
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .foregroundColor(isDark ? .white : .black)
                        .opacity(0.7)
                        .shadow(radius: 4)
                }
                .padding(20)
            }
            .sheet(isPresented: $showAddSheet) {
                AddProjectView()
                    .environmentObject(viewModel)
            }
        } else {
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
    
    private func formattedAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return "Ksh \(formatter.string(from: NSNumber(value: amount)) ?? "0")"
    }
    
    private var totalsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Total: ")
                    .font(.headline)
                
                //
                Button {
                    showAmounts.toggle()
                } label: {
                    Image(systemName: showAmounts ? "eye" : "eye.slash")
                        .foregroundColor(isDark ? .white : .black)
                }
                Spacer()
            }
            HStack(spacing: 10) {
                VStack(spacing: 5) {
                    Text("Expense")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    Text(showAmounts ? formattedAmount(viewModel.totalExpense) : "******")
                        .font(.title3)
                        .foregroundColor(.red)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
                
                VStack(spacing: 5) {
                    Text("Income")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Text(showAmounts ? formattedAmount(viewModel.totalIncome) : "******")
                        .font(.title3)
                        .foregroundColor(.green)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
    
    private var iconsSection: some View {
        HStack(spacing: 20) {
            Spacer()
            
           
                
                //
                NavigationLink(value: "tasks") {
                    VStack(spacing: 5) {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 50, height: 50)
                            .overlay(Image(systemName: "list.bullet").foregroundColor(isDark ? .white : .black))
                        Text("Tasks")
                            .font(.caption)
                            .foregroundColor(isDark ? .white : .black)
                        
                    }
                }
            
            
            Spacer()
            
                //
                NavigationLink(value: "inventory") {
                    //
                    VStack(spacing: 5){
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 50, height: 50)
                            .overlay(Image(systemName: "archivebox").foregroundColor(isDark ? .white : .black))
                        Text("Inventory")
                            .font(.caption)
                            .foregroundColor(isDark ? .white : .black)
                    }
                    
                }

            
            Spacer()
        }
    }
    
    private var projectsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Projects")
                .font(.headline)
            ForEach(viewModel.projects) { project in
                NavigationLink(destination: ProjectDetailView(project: project)) {
                    ProjectCard(project: project)
                }
            }
        }
    }
}
