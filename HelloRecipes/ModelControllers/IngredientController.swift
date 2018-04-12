//
//  IngredientController.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 3/24/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

class IngredientController {
    
    // MARK: - Constants / Variables
    static let shared = IngredientController() ; private init() {}// Singleton
    
    var ingredients = [Ingredient]() // Datasource
    
    
    // MARK: - CRUD Functions
    func add(ingredient: String) {
        let addedIngredient = Ingredient(ingredient: ingredient)
        ingredients.append(addedIngredient)
    }
    
    func remove(ingredient: Ingredient) {
        guard let indexPath = ingredients.index(of: ingredient) else { return }
        ingredients.remove(at: indexPath)
    }
    
    func edit(ingredient: Ingredient, ingredientString: String) {
        guard let indexPath = ingredients.index(of: ingredient) else { return }
        let updatedIngredient = Ingredient(ingredient: ingredientString)
        ingredients[indexPath] = updatedIngredient
    }
}
