//
//  RecipeDetailViewController.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/14/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit

/// Recipe Detail VC loads current Recipe object data from collection view cell.
internal final class RecipeDetailViewController: UIViewController {
    
    var detailRecipe: Recipe!
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var recipeImage: UIImageView!
    
    fileprivate var ingredients = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeImage.loadImageFromUrl(detailRecipe.imageUrl)
        loadIngredients(detailRecipe.recipeId)
    }
    
    private func loadIngredients(_ id: String) {
        APIRequestManager.manager.getData(imageUrl: nil, query: nil, id: id, requestType: .get) { (data) in
            if let validData = data,
                let allIngredients = Recipe.getIngredients(from: validData) {
                self.ingredients = allIngredients
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
