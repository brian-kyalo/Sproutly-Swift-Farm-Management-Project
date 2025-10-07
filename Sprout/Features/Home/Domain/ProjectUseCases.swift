// Features/Home/Domain/ProjectUseCases.swift
import Foundation
import FirebaseFirestore

struct ProjectUseCases {
    let repository: ProjectRepository
    
    init(repository: ProjectRepository) {
        self.repository = repository
    }
    
    func addProject(project: Project, imageData: Data?) async throws -> String {
        try await repository.addProject(project: project, imageData: imageData)
    }
    
    func addListenerForProjects(userId: String, onUpdate: @escaping ([Project]) -> Void) -> ListenerHandle {
        repository.addListenerForProjects(userId: userId, onUpdate: onUpdate)
    }
    
    func getExpenses(for projectId: String) async throws -> [Expense] {
        try await repository.getExpenses(for: projectId)
    }
    
    func getIncomes(for projectId: String) async throws -> [Income] {
        try await repository.getIncomes(for: projectId)
    }
    
    func addExpense(to projectId: String, expense: Expense) async throws -> String {
        try await repository.addExpense(to: projectId, expense: expense)
    }
    
    func addIncome(to projectId: String, income: Income) async throws -> String {
        try await repository.addIncome(to: projectId, income: income)
    }
}
