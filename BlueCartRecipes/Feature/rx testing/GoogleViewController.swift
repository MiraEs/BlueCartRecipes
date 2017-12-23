//
//  GoogleViewController.swift
//  BlueCartRecipes
//
//  Created by Mira Estil on 12/23/17.
//  Copyright © 2017 Mira Estil. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GoogleViewController: UIViewController {
    let disposeBag = DisposeBag()
    let model = GoogleModel()
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //[weak self]/[unowned self] prevents retain cycles
        model.createGoogleDataObservable()
            .subscribe(onNext: { [weak self] (element) in
                self?.textView.text = element
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }


}
