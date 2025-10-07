//
//  Income.swift
//  Sprout
//
//  Created by Student1 on 06/10/2025.
//

import Foundation


struct Income: Identifiable, Codable {
    // Properties
    let id: String
    let amount: Double
    let quantityDescription: String
    let date: Date
}
