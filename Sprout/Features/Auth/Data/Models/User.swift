//
//  User.swift
//  Sprout
//
//  Created by Student1 on 26/09/2025.
//

import FirebaseFirestore

// User structure that uses the codable protocol to convert to and from json
struct User: Codable {
    // User Properties
    let id: String
    let name: String
    let email: String
    
    //
    init(id: String, name: String,  email: String){
        //
        self.id = id
        self.email = email
        self.name = name
    }
    
    //
    init?(document: QueryDocumentSnapshot){
        let data = document.data()
        guard let name = data["name"] as? String,
              let email = data["email"] as? String else {
            return nil
        }
        self.id = document.documentID
        self.name = name
        self.email = email
        
    }
}
