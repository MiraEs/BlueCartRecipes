//
//  SearchRecipeViewController.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/14/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit

class SearchRecipeViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    private let reuseIdentifier = "recipeCollectionViewCell"
    private let xibId = "RecipeCollectionViewCell"
    private let endpoint = "https://food2fork.com/api/search?key=ad25b12208fee8362324f237a2ea78d2"
    private var recpies = [Recipe]()
    
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
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func setup() {
        // Collectionview cell
        let nib = UINib(nibName: xibId , bundle: Bundle(for: RecipeCollectionViewCell.self))
        
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Searchbar
        searchBar.placeholder = "Favorite Food"
    }
}

extension SearchRecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recpies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCollectionViewCell
        
        let recipeCell = recpies[indexPath.row]
        cell.data(recipeCell.title, recipeCell.imageUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension SearchRecipeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2, height: 200)
    }
}





