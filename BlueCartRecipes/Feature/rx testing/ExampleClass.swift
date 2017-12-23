//
//  ExampleClass.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/23/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ExmapleClass {
    let disposeBag = DisposeBag()
    
    func runExample() {
        // OBSERVABLE //
        
        let observable = Observable<String>.create { (observer) -> Disposable in
            DispatchQueue.global(qos: .default).async {
                Thread.sleep(forTimeInterval: 10)
                observer.onNext("Hello dummy")
                observer.onCompleted()
            }
            return Disposables.create()
        }
        // OBSERVER //
        
        observable.subscribe(onNext: {(element) in
            print(element)
        }).disposed(by: disposeBag)
    }
}
