//
//  ViewController.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/12/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let endpoint = "https://food2fork.com/api/search?key=ad25b12208fee8362324f237a2ea78d2"
    var recpies = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
    }

    // MARK: Utilies
    private func getData() {
        APIRequestManager.manager.getData(endPoint: endpoint) { (data) in
            if let validData = data,
                let recipe = Recipe.getRecipes(from: validData) {
                self.recpies = recipe
                DispatchQueue.main.async {
                    self.viewDidLoad()
                }
            }
        }
    }
    

}

