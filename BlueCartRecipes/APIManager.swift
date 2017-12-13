//
//  APIManager.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/12/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import Foundation

internal final class APIRequestManager {
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let url = URL(string: endPoint) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(String(describing: error))")
            }
            
            guard let validData = data else {
                return
            }
            callback(validData)
        }.resume()
    }
}
