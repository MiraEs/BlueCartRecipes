//
//  ViewController.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/12/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let reuseIdentifier = "recipeCell"
    private let xibId = "RecipeTableViewCell"
    private let endpoint = "https://food2fork.com/api/search?key=ad25b12208fee8362324f237a2ea78d2"
    var recpies = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        setup()
    }

    // MARK: Utilies
    private func getData() {
        APIRequestManager.manager.getData(endPoint: endpoint) { (data) in
            if let validData = data,
                let allRecipes = Recipe.getRecipes(from: validData) {
                self.recpies = allRecipes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func setup() {
        let nib = UINib(nibName: xibId , bundle: Bundle(for: RecipeTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recpies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RecipeTableViewCell
        
        let recipeCell = recpies[indexPath.row]
        cell.data(recipeCell.title, recipeCell.imageUrl)
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    
}
