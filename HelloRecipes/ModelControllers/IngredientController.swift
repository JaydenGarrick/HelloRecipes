//
//  IngredientController.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 3/24/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

/// Model Controller for Ingredient
final class IngredientController {
    
    // MARK: - Constants / Variables
    static let shared = IngredientController() ; private init() {}// Singleton
    
    var ingredients = [Ingredient]() // Datasource
    
    // MARK: - CRUD Functions
    
    /// Adds an ingredient to datasource
    func add(ingredient: String) {
        let addedIngredient = Ingredient(ingredient: ingredient)
        ingredients.append(addedIngredient)
    }
    
    /// Removes ingredient from datasource
    func remove(ingredient: Ingredient) {
        guard let indexPath = ingredients.index(of: ingredient) else { return }
        ingredients.remove(at: indexPath)
    }
    
    /// Edits an ingredients
    func edit(ingredient: Ingredient, ingredientString: String) {
        guard let indexPath = ingredients.index(of: ingredient) else { return }
        let updatedIngredient = Ingredient(ingredient: ingredientString)
        ingredients[indexPath] = updatedIngredient
    }
}
