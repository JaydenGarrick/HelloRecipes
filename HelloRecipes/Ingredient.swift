//
//  Ingredient.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 3/24/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

struct Ingredient: Equatable {
    let ingredient: String
    
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.ingredient == rhs.ingredient
    }
}

extension Collection where Element == Ingredient {
    func toURLString() -> String {
        var urlString = ""
        for ingredient in self {
            let noSpaces = ingredient.ingredient
            urlString.append("\(noSpaces) ")
        }
        return urlString.replacingOccurrences(of: " ", with: "+").trimmingCharacters(in: CharacterSet.init(charactersIn: "+"))
    }
}

