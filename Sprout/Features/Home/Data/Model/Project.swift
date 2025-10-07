//
//  Project.swift
//  Sprout
//
//  Created by Student1 on 06/10/2025.
//

import Foundation


struct Project: Identifiable , Codable{
    // Properties
    let id: String
    let title: String
    let branch: ProjectBranch
    let category: Category
    let startDate: Date
    let endDate: Date
    let imageUrl: String?
    let userId: String
}
