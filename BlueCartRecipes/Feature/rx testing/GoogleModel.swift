//
//  GoogleModel.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/23/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal final class GoogleModel {
    
    func createGoogleDataObservable() -> Observable<String> {
        
        return Observable<String>.create({ (observer) -> Disposable in
            
            let session = URLSession.shared
            let task = session.dataTask(with: URL(string:"https://www.google.com")!) { (data, response, error) in
                
                // Observer update on the UI thread
                DispatchQueue.main.async {
                    if let err = error {
                        observer.onError(err)
                    } else {
                        if let googleString = String(data: data!, encoding: .ascii) {
                            //Emit fetched element
                            observer.onNext(googleString)
                        } else {
                            //Complete sequence
                        }
                            observer.onCompleted()
                        }
                    }
                }
            
                task.resume()
                
                return Disposables.create(with: {
                    task.cancel()
                })
        })
    }
}
