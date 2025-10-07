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
    
    @State private var showAddSheet = false
    @State private var showAmounts = false
    
    var body: some View {
        if case .authenticated(let user) = authViewModel.authState {
            List {
                totalsSection
                iconsSection
                projectsSection
            }
            .listStyle(.plain)
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
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
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
    
    private var totalsSection: some View {
        Section(header: Text("Totals")) {
            HStack {
                
                

                
                Text("Total Expense:")
                Text(showAmounts ? String(format: "%.2f", viewModel.totalExpense) : "******")
                Spacer()
                Button {
                    showAmounts.toggle()
                } label: {
                    Image(systemName: showAmounts ? "eye" : "eye.slash")
                }
                
                
            }
            
            HStack {
                Text("Total Income:")
                Text(showAmounts ? String(format: "%.2f", viewModel.totalIncome) : "******")
                Spacer()
                Button {
                    showAmounts.toggle()
                } label: {
                    Image(systemName: showAmounts ? "eye" : "eye.slash")
                }
            }
        }
    }
    
    //
    private var iconsSection: some View {
        Section() {
            HStack {
                Spacer()
                NavigationLink(value: "tasks") {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 50, height: 50)
                        .overlay(Image(systemName: "list.bullet").foregroundColor(.white))
                }
                Spacer()
                NavigationLink(value: "inventory") {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 50, height: 50)
                        .overlay(Image(systemName: "archivebox").foregroundColor(.white))
                }
                Spacer()
            }
        }
    }
    
    //
    private var projectsSection: some View {
        Section(header: Text("Projects")) {
            ForEach(viewModel.projects) { project in
                NavigationLink(destination: ProjectDetailView(project: project)) {
                    ProjectCard(project: project)
                }
            }
        }
    }
    
   
}
