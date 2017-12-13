//
//  Recipe.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/12/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import Foundation

internal final class Recipe {
    let title: String
    let publisher: String
    let socialRank: Float
    let sourceUrl: URL
    
    init(title: String, publisher: String, socialRank: Float, sourceUrl: URL) {
        self.title = title
        self.socialRank = socialRank
        self.publisher = publisher
        self.sourceUrl = sourceUrl
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
                print(recipe)
                guard
                    let title = recipe["title"] as? String,
                    let publisher = recipe["publisher"] as? String,
                    let socialRank = recipe["social_rank"] as? Float,
                    let sourceUrlString = recipe["f2f_url"] as? String,
                    let sourceUrl = URL(string: sourceUrlString) else {
                        print("error parsing")
                        return nil
                }
                
                recipes.append(Recipe(title: title, publisher: publisher, socialRank: socialRank, sourceUrl: sourceUrl))
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
        return recipes
    }
    
}
