//
//  Recipe.swift
//  KODE
//
//  Created by Sergio Ramos on 02.06.2021.
//

import Foundation

struct Recipes: Codable {
    var recipes: [Recipe]
}

struct Recipe: Codable, Equatable {
    let uuid, name: String
    let images: [String]
    let lastUpdated: Int
    let description: String?
    let instructions: String
    let difficulty: Int
}
