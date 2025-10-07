import Foundation
import FirebaseFirestore

@MainActor
final class ProjectDetailViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var incomes: [Income] = []
    
    private let useCases: ProjectUseCases
    private var expenseListener: ListenerHandle?
    private var incomeListener: ListenerHandle?
    private let projectId: String
    
    init(projectId: String) {
        self.projectId = projectId
        self.useCases = ProjectUseCases(repository: DefaultProjectRepository())
    }
    
    deinit {
        expenseListener?.remove()
        incomeListener?.remove()
    }
    
    func setupListeners() {
        let expenseCollection = Firestore.firestore().collection("projects/\(projectId)/expenses")
        expenseListener = FirestoreListenerHandle(listener: expenseCollection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error listening to expenses: \(error)")
                return
            }
            let exps = snapshot?.documents.compactMap { doc -> Expense? in
                let data = doc.data()
                guard let title = data["title"] as? String,
                      let amount = data["amount"] as? Double,
                      let timestamp = data["date"] as? Timestamp else {
                    print("Failed to parse expense: \(doc.documentID), data: \(data)")
                    return nil
                }
                let date = timestamp.dateValue()
                return Expense(id: doc.documentID, title: title, amount: amount, date: date)
            } ?? []
            Task { @MainActor in
                self.expenses = exps
            }
        })
        
        let incomeCollection = Firestore.firestore().collection("projects/\(projectId)/incomes")
        incomeListener = FirestoreListenerHandle(listener: incomeCollection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error listening to incomes: \(error)")
                return
            }
            let incs = snapshot?.documents.compactMap { doc -> Income? in
                let data = doc.data()
                guard let amount = data["amount"] as? Double,
                      let quantityDescription = data["quantityDescription"] as? String,
                      let timestamp = data["date"] as? Timestamp else {
                    print("Failed to parse income: \(doc.documentID), data: \(data)")
                    return nil
                }
                let date = timestamp.dateValue()
                return Income(id: doc.documentID, amount: amount, quantityDescription: quantityDescription, date: date)
            } ?? []
            Task { @MainActor in
                self.incomes = incs
            }
        })
    }
    
    func addExpense(_ expense: Expense) async throws -> String {
        try await useCases.addExpense(to: projectId, expense: expense)
    }
    
    func addIncome(_ income: Income) async throws -> String {
        try await useCases.addIncome(to: projectId, income: income)
    }
}
