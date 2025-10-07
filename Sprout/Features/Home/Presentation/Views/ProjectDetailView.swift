import Foundation
import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    let projectId: String 
    @StateObject private var viewModel: ProjectDetailViewModel
    @State private var showAddExpense = false
    @State private var showAddIncome = false
    
    init(project: Project) {
        self.project = project
        self.projectId = project.id
        self._viewModel = StateObject(wrappedValue: ProjectDetailViewModel(projectId: project.id))
    }
    
    var body: some View {
        List {
            Section(header: Text("Project Details")) {
                Text("Title: \(project.title)")
                Text("Branch: \(project.branch.rawValue.capitalized)")
                Text("Category: \(project.category.rawValue.capitalized)")
                Text("Start: \(project.startDate, style: .date)")
                Text("End: \(project.endDate, style: .date)")
            }
            Section(header: Text("Expenses")) {
                ForEach(viewModel.expenses) { expense in
                    HStack {
                        Text(expense.title)
                        Spacer()
                        Text(String(format: "%.2f", expense.amount))
                    }
                }
                Button("Add Expense") { showAddExpense = true }
            }
            Section(header: Text("Incomes")) {
                ForEach(viewModel.incomes) { income in
                    HStack {
                        Text(income.quantityDescription)
                        Spacer()
                        Text(String(format: "%.2f", income.amount))
                    }
                }
                Button("Add Income") { showAddIncome = true }
            }
        }
        .navigationTitle(project.title)
        .onAppear {
            viewModel.setupListeners()
            print("ProjectDetailView appeared for project: \(projectId)")
        }
        .sheet(isPresented: $showAddExpense) {
            AddExpenseView { expense in
                Task {
                    do {
                        _ = try await viewModel.addExpense(expense)
                        print("Expense added: \(expense.title)")
                    } catch {
                        print("Error adding expense: \(error)")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddIncome) {
            AddIncomeView { income in
                Task {
                    do {
                        _ = try await viewModel.addIncome(income)
                        print("Income added: \(income.quantityDescription)")
                    } catch {
                        print("Error adding income: \(error)")
                    }
                }
            }
        }
    }
}
