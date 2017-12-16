//
//  SearchRecipeViewController.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/14/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit
import CoreData

/// Initial VC with preloaded data of top 30 recipes.
internal final class SearchRecipeViewController: UIViewController {
    
    @IBOutlet private weak var searchLabel: UILabel! {
        didSet {
            searchLabel.text = Constants.searchLabelText
        }
    }
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var recipes = [Recipe]()
    private var filteredRecipes = [Recipe]()
    private var searchEntries: [NSManagedObject] = []
    private var recipeSearches: [NSManagedObject] = []
    
    //TODO: ******Fake data used temporarily - API down
    private var fakeRecipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getFakeData()
        getData(with: .search)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadSavedData()
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
            } else {
                if !self.recipeSearches.isEmpty {
                    self.recipeSearches.forEach({ (storedRecipe) in
                        self.recipes.append(Recipe(title: storedRecipe.value(forKey: Constants.titleKey) as! String,
                                              socialRank: nil, imageUrl: storedRecipe.value(forKey: Constants.imageKey) as! String,
                                              recipeId: storedRecipe.value(forKey: Constants.recipeIdKey) as! String))
                    })
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
    
    //TODO: ******Fake data used temporarily - API down
    private func getFakeData() {
        let foods = ["Chicken", "Pizza", "Madeleines", "Tiramisu", "Lattes", "More Pizza", "Clam Chowder", "Bubble Tea"]
        let imageUrl = "https://imgix.ranker.com/user_node_img/50019/1000371390/original/another-awesome-einstein-photo-u1?w=650&q=50&fm=jpg&fit=crop&crop=faces"
        for i in 0..<foods.count {
            fakeRecipes.append(Recipe(title: foods[i], socialRank: 100.0, imageUrl: imageUrl, recipeId: "id"))
        }
        recipes = fakeRecipes
    }
    
    // MARK: SETUP
    
    private func setup() {
        // CollectionView xib
        let nib = UINib(nibName: Constants.xibId , bundle: Bundle(for: RecipeCollectionViewCell.self))
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.reuseIdentifier)
        
        // CollectionView Layout
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
        navigationItem.titleView?.backgroundColor = UIColor.blue
        self.title = Constants.mainPageTitle
        
        // Stored Data
        loadSavedData()
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
            saveSearchRecipes(recipe)
            return recipe.title.lowercased().contains(searchText.lowercased())
        })
        collectionView.reloadData()
    }
    
    private func updateSearchLabel(_ isSearching: Bool) {
        if isSearching {
            // While user is typing, showcase recent searches.
            var searches = String()
            searchEntries.reversed().forEach({ (search) in
                if let search = search.value(forKey: Constants.entryKey) as? String {
                    searches += "\(search),"
                }
            })
            searchLabel.text = "Recent searches: \(searches)"
        } else {
            // When user hits return, showcase search count.
            if isFiltering() {
                searchLabel.text = "\(filteredRecipes.count) recipes found"
            } else {
                searchLabel.text = "\(recipes.count) recipes found"
            }
        }
    }
    
    // MARK: PERSISTENCE
    /// Saves previously search texts.
    private func saveSearch(_ searchText: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.searchEntity, in: managedContext)!
        let searchEntry = NSManagedObject(entity: entity, insertInto: managedContext)
        searchEntry.setValue(searchText, forKey: Constants.entryKey)
        
        do {
            try managedContext.save()
            searchEntries.append(searchEntry)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /// Saves recently searched and loaded recipes.
    private func saveSearchRecipes(_ recipe: Recipe) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let recipeEntity = NSEntityDescription.entity(forEntityName: Constants.recipeEntity, in: managedContext)!
        let recipeSearch = NSManagedObject(entity: recipeEntity, insertInto: managedContext)
        recipeSearch.setValuesForKeys([
            Constants.recipeIdKey: recipe.recipeId,
            Constants.titleKey: recipe.title,
            Constants.imageKey: recipe.imageUrl
            ])
        
        do {
            try managedContext.save()
            recipeSearches.append(recipeSearch)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /// Loads previously searched texts.
    private func loadSavedData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequestSearches = NSFetchRequest<NSManagedObject>(entityName: Constants.searchEntity)
        let fetchRequestRecipes = NSFetchRequest<NSManagedObject>(entityName: Constants.recipeEntity)

        do {
            searchEntries = try managedContext.fetch(fetchRequestSearches)
            recipeSearches = try managedContext.fetch(fetchRequestRecipes)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
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
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier,
                                                      for: indexPath) as! RecipeCollectionViewCell
        
        var recipeCell: Recipe
        recipeCell = isFiltering() ? filteredRecipes[indexPath.row] : recipes[indexPath.row]
        cell.data(recipeCell.title, recipeCell.imageUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueId, sender: indexPath)
    }
}

extension SearchRecipeViewController: CustomLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return Constants.photoHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentYoffset = scrollView.contentOffset.y
        let translationY = view.frame.width/2

        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                if currentYoffset > 0 {
                    self?.navigationItem.titleView?.transform = CGAffineTransform(translationX: 0, y: -translationY)
                } else {
                    self?.navigationItem.titleView?.transform = CGAffineTransform.identity
                }
            }, completion: nil)
    }
}

extension SearchRecipeViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getDataFilter(searchController.searchBar.text!)
        saveSearch(searchController.searchBar.text!)
        updateSearchLabel(false)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        updateSearchLabel(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = nil
        updateSearchLabel(false)
    }
}





