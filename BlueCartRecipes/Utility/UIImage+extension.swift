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
        let imageCache = NSCache<NSString, UIImage>()
        // Check if Cached
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            self.image = cachedImage
            return
        }
        
        // If not in cache, url request
        APIRequestManager.manager.getData(imageUrl: url, query: nil, id: nil, requestType: .image) { (data: Data?) in
            if data != nil {
                if let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        imageCache.setObject(validImage, forKey: url as NSString)
                       self.image = validImage
                    }
                }
            }
        }
    }
}

