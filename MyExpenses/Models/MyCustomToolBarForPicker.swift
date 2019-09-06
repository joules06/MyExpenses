//
//  MyCustomToolBarForPicker.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/6/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
import UIKit

struct MyCustomToolBarForPicker {
    static func addToolBarToPickerView(textField: UITextField, okAction: Selector?, cancelAction: Selector?) {
        let toolBar = UIToolbar()
        
        toolBar.barStyle = .default
        toolBar.tintColor = UIColor.black
        toolBar.backgroundColor = UIColor(hexString: GlobalVariables.hexForPrimaryColor)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: okAction)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: cancelAction)
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
    }
}
