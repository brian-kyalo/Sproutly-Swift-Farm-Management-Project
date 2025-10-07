import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var totalExpense: Double = 0.0
    @Published var totalIncome: Double = 0.0
    
    private let useCases: ProjectUseCases
    private var listener: ListenerHandle?
    
    init(useCases: ProjectUseCases = ProjectUseCases(repository: DefaultProjectRepository())) {
        self.useCases = useCases
    }
    
    deinit {
        listener?.remove()
    }
    
    func setupListeners(userId: String) {
        listener = useCases.addListenerForProjects(userId: userId) { [weak self] projects in
            Task { @MainActor in
                self?.projects = projects
                self?.calculateTotals()
            }
        }
    }
    
    func calculateTotals() {
        Task {
            var exp = 0.0
            var inc = 0.0
            
            for project in projects {
                let expenses = try await useCases.getExpenses(for: project.id)
                exp += expenses.reduce(0) { $0 + $1.amount }
                let incomes = try await useCases.getIncomes(for: project.id)
                inc += incomes.reduce(0) { $0 + $1.amount }
            }
            await MainActor.run {
                self.totalExpense = exp
                self.totalIncome = inc
            }
        }
    }
    
    func addProject(project: Project, imageData: Data?) async throws {
        _ = try await useCases.addProject(project: project, imageData: imageData)
    }
}
