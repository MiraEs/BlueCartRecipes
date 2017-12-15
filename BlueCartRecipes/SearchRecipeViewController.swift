//
//  SearchRecipeViewController.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/14/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit

class SearchRecipeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let reuseIdentifier = "recipeCollectionViewCell"
    private let xibId = "RecipeCollectionViewCell"
    private let endpoint = "https://food2fork.com/api/search?key=ad25b12208fee8362324f237a2ea78d2"
    private var recipes = [Recipe]()
    private var filteredRecipes = [Recipe]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Functions
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
                self.recipes = allRecipes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func setup() {
        // CollectionView xib
        let nib = UINib(nibName: xibId , bundle: Bundle(for: RecipeCollectionViewCell.self))
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        //CollectionView Layout
        if let layout = collectionView?.collectionViewLayout as? ColumnLayout {
            layout.delegate = self
            layout.numberOfColumns = 2
        }
        
        // Searchbar
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Foodies search"
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        //searchController.searchBar.becomeFirstResponder()
        navigationItem.titleView = searchController.searchBar
    }
    
    //MARK: Search bar helper functions
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredRecipes = recipes.filter({(recipe: Recipe) -> Bool in
            return recipe.title.lowercased().contains(searchText.lowercased())
        })
        collectionView.reloadData()
    }
    
    private func getDataFilter(_ searchText: String) {
        APIRequestManager.manager.getDataWithQuery(endPoint: endpoint, query: searchText) { (data) in
            if let validData = data,
                let allRecipes = Recipe.getRecipes(from: validData) {
                self.filteredRecipes = allRecipes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension SearchRecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredRecipes.count
        }
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCollectionViewCell
        
        var recipeCell: Recipe
        if isFiltering() {
            recipeCell = filteredRecipes[indexPath.row]
        } else {
            recipeCell = recipes[indexPath.row]
        }
        cell.data(recipeCell.title, recipeCell.imageUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension SearchRecipeViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return 200
    }
}

extension SearchRecipeViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarTexatDidEndEditing(_ searchBar: UISearchBar) {
        getDataFilter(searchController.searchBar.text!)
    }
    
}








