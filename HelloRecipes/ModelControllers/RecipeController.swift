//
//  RecipeController.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 3/24/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

/// Model Controller for Recipes
class RecipeController {
    
    /// Method to fetch recipes with array of Ingredients
    static func fetchRecipes(with ingredients: [Ingredient], completion: @escaping (([MyRecipie]?)->Void)) {
        
        // url
        let baseUrlString = "https://api.edamam.com"
        guard var url = URL(string: baseUrlString) else { completion(nil) ; return }
        url.appendPathComponent("search")
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
        let queryItem = URLQueryItem(name: "q", value: ingredients.toURLString())
        let appIdQueryItem = URLQueryItem(name: "app_id", value: "cba9df35")
        let appKeyQueryItem = URLQueryItem(name: "app_key", value: "29bcc5c4b5ce1b7ddbf437f106c04b9f")
        components?.queryItems = [queryItem, appIdQueryItem, appKeyQueryItem]
        guard let requestUrl = components?.url else { completion(nil) ; return }
        print("🛰📡  \(requestUrl)  📡🛰    <-- is the URL used for the gathered Recipes")
        
        // request
        var request = URLRequest(url: requestUrl)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        // dataTask + resume
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("❌Error fetching recipes: \(error.localizedDescription)")
                completion(nil)
            }
            guard let data = data else { completion(nil) ; return }
            do {
                let decoder = JSONDecoder()
                let topLevelData = try decoder.decode(TopLeveldata.self, from: data)
                var fetchedRecipes = [MyRecipie]()
                topLevelData.hits.forEach {
                    fetchedRecipes.append($0.recipe)
                }
                print("✅Successfully fetched recipes!")
                completion(fetchedRecipes)
            } catch {
                print("Decoder Error while fetching recipes: \(error.localizedDescription)")
                completion(nil)
            }
            
            }.resume()
    }
    
    /// Method to download Image with URL
    static func downloadImageWith(urlString: String, completion: @escaping ((UIImage?)->Void)) {
        
        // url
        guard let imageUrl = URL(string: urlString) else { completion(nil) ; print("error with url") ; return }
        
        // request
        var request = URLRequest(url: imageUrl)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        // dataTask + resume
        URLSession.shared.dataTask(with: request) { (data, _, error) in
         
            if let error = error {
                print("❌Error fetching image from recipe image url: \(error.localizedDescription)")
                completion(nil)
            }
            guard let data = data else { completion(nil) ; return }
            completion(UIImage(data: data))
        }.resume()
    }
    
}




