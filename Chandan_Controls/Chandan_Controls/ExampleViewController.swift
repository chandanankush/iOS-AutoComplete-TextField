//
//  ViewController.swift
//  Chandan_Controls
//
//  Created by Gudia on 11/02/24.
//  Copyright © 2024 Chandan SIngh. All rights reserved.
//

import Foundation
import UIKit
import CAAutoFillTextField

class ExampleViewController: UIViewController {
    
    @IBOutlet private weak var myTextField: CAAutoFillTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        var tempArray: [CAAutoCompleteObject] = []
        for i in 0...10 {
            let object = CAAutoCompleteObject(objName: "drop down \(i)", AndID: i)
            tempArray.append(object)
        }
        myTextField.dataSourceArray = tempArray
        myTextField.clipsToBounds = false
        myTextField.delegate = self
    }
}

extension ExampleViewController: CAAutoFillDelegate {

    func caAutoTextFillBeginEditing() {
        
    }

    func caAutoTextFillEndEditing() {
        
    }

    func caAutoTextCanEdit() -> Bool {
        return true
    }
}
