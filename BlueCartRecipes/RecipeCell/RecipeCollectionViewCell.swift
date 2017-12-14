//
//  RecipeCollectionViewCell.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/14/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    func data(_ title: String, _ imageUrl: String) {
        self.recipeTitle.text = title
        downloadImage(imageUrl)
    }
    
    private func downloadImage(_ url: String) {
        APIRequestManager.manager.getData(endPoint: url) { (data: Data?) in
            if data != nil {
                if let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        self.recipeImage.image = validImage
                    }
                }
            }
        }
    }


}
