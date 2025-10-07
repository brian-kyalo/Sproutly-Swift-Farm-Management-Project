import Foundation
import FirebaseFirestore

protocol ListenerHandle {
    func remove()
}

class FirestoreListenerHandle: ListenerHandle {
    private let listener: ListenerRegistration
    
    init(listener: ListenerRegistration) {
        self.listener = listener
    }
    
    func remove() {
        listener.remove()
    }
}
