//
//  ProjectRepo.swift
//  Sprout
//
//  Created by Student1 on 06/10/2025.
//

import Foundation
import FirebaseFirestore

//
protocol ProjectRepository {
    func addProject(project: Project, imageData: Data?) async throws -> String
    func addListenerForProjects(userId: String, onUpdate: @escaping ([Project]) -> Void) -> ListenerHandle
    func getExpenses(for projectId: String) async throws -> [Expense]
    func getIncomes(for projectId: String) async throws -> [Income]
    func addExpense(to projectId: String, expense: Expense) async throws -> String
    func addIncome(to projectId: String, income: Income) async throws -> String
}



class DefaultProjectRepository: ProjectRepository {
    private let service: FirebaseProjectService
    
    init(service: FirebaseProjectService = FirebaseProjectService()) {
        self.service = service
    }
    
    func addProject(project: Project, imageData: Data?) async throws -> String {
        try await service.addProject(project: project, imageData: imageData)
    }
    
    func addListenerForProjects(userId: String, onUpdate: @escaping ([Project]) -> Void) -> ListenerHandle {
        service.addListenerForProjects(userId: userId, onUpdate: onUpdate)
    }
    
    func getExpenses(for projectId: String) async throws -> [Expense] {
        try await service.getExpenses(for: projectId)
    }
    
    func getIncomes(for projectId: String) async throws -> [Income] {
        try await service.getIncomes(for: projectId)
    }
    
    func addExpense(to projectId: String, expense: Expense) async throws -> String {
        try await service.addExpense(to: projectId, expense: expense)
    }
    
    func addIncome(to projectId: String, income: Income) async throws -> String {
        try await service.addIncome(to: projectId, income: income)
    }
}
