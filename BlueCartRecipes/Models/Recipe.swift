//
//  Recipe.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/12/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import Foundation

/// Class builds out Recipe object.
internal final class Recipe {
    let title: String
    let publisher: String
    let socialRank: Float
    let sourceUrl: URL
    let imageUrl: String
    let recipeId: String
    
    init(title: String, publisher: String, socialRank: Float, sourceUrl: URL, imageUrl: String, recipeId: String) {
        self.title = title
        self.socialRank = socialRank
        self.publisher = publisher
        self.sourceUrl = sourceUrl
        self.imageUrl = imageUrl
        self.recipeId = recipeId
    }
    
    static func getRecipes(from data: Data) -> [Recipe]? {
        var recipes = [Recipe]()
        
        do {
            let data = try JSONSerialization.jsonObject(with: data, options: [])
            guard let validData = data as? [String:Any] else {
                print("error serializing")
                return nil
            }
            
            guard let recipeDict = validData["recipes"] as? [[String:Any]] else {
                print("error recipe data")
                return nil
            }
            
            for recipe in recipeDict {
                guard
                    let title = recipe["title"] as? String,
                    let publisher = recipe["publisher"] as? String,
                    let socialRank = recipe["social_rank"] as? Float,
                    let sourceUrlString = recipe["f2f_url"] as? String,
                    let sourceUrl = URL(string: sourceUrlString),
                    let imageUrl = recipe["image_url"] as? String,
                    let recipeId = recipe["recipe_id"] as? String else {
                        print("error parsing")
                        return nil
                }
                
                recipes.append(Recipe(title: title, publisher: publisher, socialRank: socialRank, sourceUrl: sourceUrl, imageUrl: imageUrl, recipeId: recipeId))
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
        return recipes
    }
    
    static func getIngredients(from data: Data) -> [String]? {
        var ingredients = [String]()
        
        do {
            let data = try JSONSerialization.jsonObject(with: data, options: [])
            guard let validData = data as? [String:Any] else {
                print("error serializing")
                return nil
            }
            
            guard let recipeDict = validData["recipe"] as? [String:Any] else {
                print("error recipe data")
                return nil
            }
            
            guard let ingredientsArray = recipeDict["ingredients"] as? [String] else {
                return nil
            }
            
            for ingredient in ingredientsArray {
                ingredients.append(ingredient)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
        return ingredients
    }
    
}
