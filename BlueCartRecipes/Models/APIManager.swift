//
//  APIManager.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/12/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import Foundation

// Network requests
enum RequestType: String {
    case get
    case search
    case query
    case image
}

// API Manager class includes "manager" singleton to handle different network requests.
internal final class APIRequestManager {
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(imageUrl: String?, query: String?, id: String?, requestType: RequestType, callback: @escaping (Data?) -> Void) {
        let endPoint = "https://food2fork.com/api/"
        let key = "?key=ad25b12208fee8362324f237a2ea78d2"
        var path = ""
        
        switch requestType {
        case .search:
            path = endPoint + requestType.rawValue + key
        case .get:
            guard let id = id else { return }
            path = endPoint + requestType.rawValue + key + "&rId=" + id
        case .query:
            guard let queryString = query?.replacingOccurrences(of: " ", with: "%20") else {
                return
            }
            path = endPoint + RequestType.search.rawValue + key + "&q=" + queryString
        case .image:
            guard let imageUrl = imageUrl else { return }
            path = imageUrl
        }
    
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
