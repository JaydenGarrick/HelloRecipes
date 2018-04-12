//
//  Recipe.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 3/24/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

struct TopLeveldata: Decodable {
    let hits: [Recipe]
    let to: Int
}

struct Recipe: Decodable {
    let recipe: MyRecipie
}

struct MyRecipie: Decodable {
    let label: String?
    let image: String?
    let ingredientLines: [String]?
    let source: String?
    let url: String?
}
