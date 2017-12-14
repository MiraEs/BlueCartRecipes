//
//  RecipeTableViewCell.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/13/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    

    
    func data(_ title: String, _ imageUrl: String) {
        recipeLabel.text = title
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
