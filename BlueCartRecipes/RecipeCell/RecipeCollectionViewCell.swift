//
//  RecipeCollectionViewCell.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/14/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit

/// Recipe Collection View Cell includes detailed data on target Recipe object.
internal final class RecipeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    /// Instantiate recipe cell data from Collection View Cell Delegate.
    ///
    /// - Returns: Recipe object data.
    func data(_ title: String, _ imageUrl: String) {
        
        self.recipeTitle.text = title
        recipeImage.loadImageFromUrl(imageUrl)
    }
}
