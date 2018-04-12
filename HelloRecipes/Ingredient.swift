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
