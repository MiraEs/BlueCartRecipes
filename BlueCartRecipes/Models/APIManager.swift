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
    
    func getDataWithQuery(endPoint: String, query: String, callback: @escaping (Data?) -> Void) {
        let queryString = query.replacingOccurrences(of: " ", with: "%20")

        guard let url = URL(string: endPoint+queryString) else {
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
    
//    private let endpoint = "https://food2fork.com/api/"
//    private let key = "?key=ad25b12208fee8362324f237a2ea78d2&rId="
//    private let search = "search"
//    private let get = "get"
    
    func getRecipeData(id: String, callback: @escaping (Data?) -> Void) {
        let endpoint = "https://food2fork.com/api/"
        let key = "?key=ad25b12208fee8362324f237a2ea78d2&rId="
        let get = "get"
        
        let path = endpoint + get + key + id
        guard let url = URL(string: path) else {
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
