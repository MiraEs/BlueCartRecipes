//
//  Constants.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/14/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    // MARK: SEARCH RECIPE VC
    static let reuseIdentifier = "recipeCollectionViewCell"
    static let xibId = "RecipeCollectionViewCell"
    static let segueId = "recipeDetailSegue"
    static let searchPlaceholder = "Search a recipe"
    static let mainPageTitle = "Search for Recipes"
    static let searchLabelText = "Start searching your fav recipes!"
    
    // MARK: RECIPE DETAIL VC
    static let rdReuseIdentifier = "recipeDetailCell"
    
    // MARK: API
    static let baseEndpoint = "https://food2fork.com/api/search?key=ad25b12208fee8362324f237a2ea78d2"
    
    // MARK: CORE DATA
    static let searchEntity = "SearchEntry"
    static let entryKey = "entry"
    
    //MARK: UI - SEARCH RECIPE COLLECTION VIEW
    static let photoHeight: CGFloat = 200
}
