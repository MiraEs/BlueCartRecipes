//
//  RecipeDetailViewController.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/14/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit


internal final class RecipeDetailViewController: UIViewController {
    
    var detailRecipe: Recipe!
    fileprivate var ingredients = [String]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadImage(detailRecipe.imageUrl)
        loadIngredients(detailRecipe.recipeId)
    }
    
    private func loadIngredients(_ id: String) {
        APIRequestManager.manager.getRecipeData(id: id) { (data) in
            if let validData = data,
                let allIngredients = Recipe.getIngredients(from: validData) {
                self.ingredients = allIngredients
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    private func downloadImage(_ url: String) {
        APIRequestManager.manager.getData(imageUrl: url, query: nil, id: nil, requestType: .image) { (data: Data?) in
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

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.rdReuseIdentifier, for: indexPath)
        cell.textLabel?.text = ingredients[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
}
