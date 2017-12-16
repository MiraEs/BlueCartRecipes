//
//  UIImage+extension.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/15/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageFromUrl(_ url: String) {
        APIRequestManager.manager.getData(imageUrl: url, query: nil, id: nil, requestType: .image) { (data: Data?) in
            if data != nil {
                if let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                       self.image = validImage
                    }
                }
            }
        }
    }
}

