//
//  SearchRecipeViewController.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/14/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit

/// Initial VC
internal final class SearchRecipeViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var recipes = [Recipe]()
    private var filteredRecipes = [Recipe]()
    private var pastSearches = [String]()
    
    fileprivate let photoHeight: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(with: .search)
        setup()
    }
    
    // MARK: NETWORK
    
    private func getData(with request: RequestType) {
        APIRequestManager.manager.getData(imageUrl: nil, query: nil, id: nil, requestType: request) { (data) in
            if let validData = data,
                let allRecipes = Recipe.getRecipes(from: validData) {
                self.recipes = allRecipes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func getDataFilter(_ searchText: String) {
        APIRequestManager.manager.getData(imageUrl: nil, query: searchText, id: nil, requestType: .get) { (data) in
            if let validData = data,
                let allRecipes = Recipe.getRecipes(from: validData) {
                self.filteredRecipes = allRecipes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: SETUP
    
    private func setup() {
        // CollectionView xib
        let nib = UINib(nibName: Constants.xibId , bundle: Bundle(for: RecipeCollectionViewCell.self))
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.reuseIdentifier)
        
        //CollectionView Layout
        if let layout = collectionView?.collectionViewLayout as? ColumnLayout {
            layout.delegate = self
            layout.numberOfColumns = 2
        }
        
        // Searchbar
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchPlaceholder
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        navigationItem.title = Constants.mainPageTitle
    }
    
    //MARK: SEARCH BAR FUNCTIONALITY
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredRecipes = recipes.filter({(recipe: Recipe) -> Bool in
            return recipe.title.lowercased().contains(searchText.lowercased())
        })
        collectionView.reloadData()
    }
    
    /// Saves searches in a fixed-length array to avoid over memory allocation.
    /// Array resets after limit is reached.
    private func saveSearch(_ searchText: String) {
        if pastSearches.count == 20 {
            pastSearches = []
        } else {
            pastSearches.append(searchText)
        }
        print(pastSearches)
    }
    
    //MARK: SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueId {
            guard let selectedIndexPath = sender as? IndexPath,
                let dvc = segue.destination as? RecipeDetailViewController else {
                    return
            }
            
            if isFiltering() {
                dvc.detailRecipe = filteredRecipes[selectedIndexPath.row]
            } else {
                dvc.detailRecipe = recipes[selectedIndexPath.row]
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! RecipeCollectionViewCell
        
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
        performSegue(withIdentifier: Constants.segueId, sender: indexPath)
    }
}

extension SearchRecipeViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return photoHeight
    }
}

extension SearchRecipeViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getDataFilter(searchController.searchBar.text!)
        saveSearch(searchController.searchBar.text!)
    }
}








