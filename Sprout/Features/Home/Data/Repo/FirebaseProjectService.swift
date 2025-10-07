import Foundation
import FirebaseFirestore
import FirebaseStorage

enum StorageError: Error {
    case unknownError
}

extension StorageReference {
    func putDataAsync(_ data: Data, metadata: StorageMetadata?) async throws -> StorageMetadata {
        try await withCheckedThrowingContinuation { continuation in
            putData(data, metadata: metadata) { metadata, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let metadata = metadata {
                    continuation.resume(returning: metadata)
                } else {
                    continuation.resume(throwing: StorageError.unknownError)
                }
            }
        }
    }

    func downloadURLAsync() async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            downloadURL { url, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let url = url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: StorageError.unknownError)
                }
            }
        }
    }
}

final class FirebaseProjectService {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func addProject(project: Project, imageData: Data?) async throws -> String {
        let projectRef = db.collection("projects").document()
        let projectId = projectRef.documentID
        
        var imageUrl: String? = nil
        if let data = imageData {
            let imagePath = "project_images/\(projectId).jpg"
            let imageRef = storage.reference().child(imagePath)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            _ = try await imageRef.putDataAsync(data, metadata: metadata)
            let url = try await imageRef.downloadURLAsync()
            imageUrl = url.absoluteString
        }
        
        let data: [String: Any] = [
            "title": project.title,
            "branch": project.branch.rawValue,
            "category": project.category.rawValue,
            "startDate": Timestamp(date: project.startDate),
            "endDate": Timestamp(date: project.endDate),
            "imageUrl": imageUrl as Any,
            "userId": project.userId
        ]
        
        try await projectRef.setData(data)
        return projectId
    }
    
    func addListenerForProjects(userId: String, onUpdate: @escaping ([Project]) -> Void) -> ListenerHandle {
        let listener = db.collection("projects").whereField("userId", isEqualTo: userId).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error listening to projects: \(error)")
                onUpdate([])
                return
            }
            let projects = snapshot?.documents.compactMap { doc -> Project? in
                let data = doc.data()
                guard let title = data["title"] as? String,
                      let branchStr = data["branch"] as? String,
                      let branch = ProjectBranch(rawValue: branchStr),
                      let categoryStr = data["category"] as? String,
                      let category = Category(rawValue: categoryStr),
                      let startTimestamp = data["startDate"] as? Timestamp,
                      let endTimestamp = data["endDate"] as? Timestamp,
                      let userId = data["userId"] as? String else {
                    print("Failed to parse project: \(doc.documentID), data: \(data)")
                    return nil
                }
                let startDate = startTimestamp.dateValue()
                let endDate = endTimestamp.dateValue()
                let imageUrl = data["imageUrl"] as? String
                return Project(id: doc.documentID, title: title, branch: branch, category: category, startDate: startDate, endDate: endDate, imageUrl: imageUrl, userId: userId)
            } ?? []
            onUpdate(projects)
        }
        return FirestoreListenerHandle(listener: listener)
    }
    
    func getExpenses(for projectId: String) async throws -> [Expense] {
        let snapshot = try await db.collection("projects/\(projectId)/expenses").getDocuments()
        return snapshot.documents.compactMap { doc -> Expense? in
            let data = doc.data()
            guard let title = data["title"] as? String,
                  let amount = data["amount"] as? Double,
                  let timestamp = data["date"] as? Timestamp else {
                print("Failed to parse expense: \(doc.documentID), data: \(data)")
                return nil
            }
            let date = timestamp.dateValue()
            return Expense(id: doc.documentID, title: title, amount: amount, date: date)
        }
    }
    
    func getIncomes(for projectId: String) async throws -> [Income] {
        let snapshot = try await db.collection("projects/\(projectId)/incomes").getDocuments()
        return snapshot.documents.compactMap { doc -> Income? in
            let data = doc.data()
            guard let amount = data["amount"] as? Double,
                  let quantityDescription = data["quantityDescription"] as? String,
                  let timestamp = data["date"] as? Timestamp else {
                print("Failed to parse income: \(doc.documentID), data: \(data)")
                return nil
            }
            let date = timestamp.dateValue()
            return Income(id: doc.documentID, amount: amount, quantityDescription: quantityDescription, date: date)
        }
    }
    
    func addExpense(to projectId: String, expense: Expense) async throws -> String {
        let ref = db.collection("projects/\(projectId)/expenses").document()
        let data: [String: Any] = [
            "title": expense.title,
            "amount": expense.amount,
            "date": Timestamp(date: expense.date)
        ]
        try await ref.setData(data)
        return ref.documentID
    }
    
    func addIncome(to projectId: String, income: Income) async throws -> String {
        let ref = db.collection("projects/\(projectId)/incomes").document()
        let data: [String: Any] = [
            "amount": income.amount,
            "quantityDescription": income.quantityDescription,
            "date": Timestamp(date: income.date)
        ]
        try await ref.setData(data)
        return ref.documentID
    }
}
