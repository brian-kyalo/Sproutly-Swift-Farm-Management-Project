//
//  FirebaseAuthService.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import FirebaseAuth
import FirebaseFirestore

//
class FirebaseAuthService{
    // Registration
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            //
            guard let uid = result?.user.uid else {
                completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to get User ID"])))
                return
            }
            //
            Firestore.firestore().collection("users").document(uid).setData([
                "name": name,
                "email": email
            ]) {error in
                if let error = error {
                    completion(.failure(error))
                    
                    
                }else {
                    completion(.success(uid))
                }
            }
        }
    }
    
    // Login
    func signIn(email: String, password:String, completion: @escaping (Result<Void, Error>) -> Void) {
        //
        Auth.auth().signIn(withEmail: email, password: password){_, error in
            if let error = error {
                completion(.failure(error))
            }else{
                completion(.success(()))
            }
        }
    }
    
    //Logout
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // Forgot Password
    func forgotPassword(email: String, completion: @escaping (Result<Void, Error>)-> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) {
            error in if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
