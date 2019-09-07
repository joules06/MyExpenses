//
//  GlobalUtils.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/5/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//
import RealmSwift
import Foundation
import UIKit

class GlobalUtils {
    static func addIconToTextField(textField: UITextField, imageName: String, isLeft: Bool) {
        let heightImage = 20
        let widthImage = 20
        
        let imageView = UIImageView()
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.frame = CGRect(x: 5, y: 5, width: widthImage, height: heightImage)
        if isLeft {
            textField.leftView = imageView
            textField.leftViewMode = .always
        } else {
            textField.rightView = imageView
            textField.rightViewMode = .always
        }
    }
    
    static func formatNumberToCurrency(value: Double) -> String {
        var valueAsCurrency: String = ""
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        if let valueFormatted = formatter.string(from: value as NSNumber) {
            valueAsCurrency = valueFormatted
        } else {
            valueAsCurrency = String(format: "%.2f", value)
        }
        
        return valueAsCurrency
    }
    
    static func changeHeightForTextField(textField: UITextField, desiredHeight: CGFloat) {
        var frameRectangular = textField.frame
        frameRectangular.size.height = desiredHeight
        textField.frame = frameRectangular
    }
    
    static func addBottomBorderToTextField(textField: UITextField) {
        let border = CALayer()
        let widthForBorder = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        print(textField.frame.size.height - widthForBorder)
        border.frame = CGRect(x: 0, y: textField.frame.size.height - widthForBorder, width: textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = widthForBorder
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    static func makeProgressBar(with amountSpent: Double, maximunValue: Double, labelForText: UILabel, viewToDraw: UIView){
        
        let width = viewToDraw.frame.width - 20
        var progressWidht = maximunValue >= 0 ? amountSpent * Double(width) / maximunValue : 0
        var cgColorForProgessBar : CGColor
        let percentage = maximunValue >= 0 ? amountSpent / maximunValue : 0
        
        
        if percentage > 0 && percentage <= 0.20{
            cgColorForProgessBar = UIColor(hexString: GlobalVariables.hexForPrimaryColor).cgColor
        } else if percentage > 0.20  && percentage <= 0.60 {
            cgColorForProgessBar = UIColor.flatLime()?.cgColor ?? UIColor.orange.cgColor
        } else if percentage > 0.60 && percentage <= 0.70 {
            cgColorForProgessBar = UIColor.flatYellow()?.cgColor ?? UIColor.yellow.cgColor
        } else if percentage > 0.70 && percentage <= 0.80 {
            cgColorForProgessBar = UIColor.flatLime()?.cgColor ?? UIColor.red.cgColor
        } else {
            cgColorForProgessBar = UIColor.flatRedColorDark()?.cgColor ?? UIColor.brown.cgColor
        }
        
        if amountSpent >= maximunValue {
            progressWidht = Double(width)
        }
        
        let baseLayer = CAShapeLayer()
        baseLayer.path = UIBezierPath(roundedRect: CGRect(x: 10, y: 0, width: width, height: 10), cornerRadius: 50).cgPath
        baseLayer.fillColor = UIColor.gray.cgColor
        
        let percentageLayer = CAShapeLayer()
        percentageLayer.path = UIBezierPath(roundedRect: CGRect(x: 10, y: 0, width: CGFloat(progressWidht), height: 10), cornerRadius: 50).cgPath
        percentageLayer.fillColor = cgColorForProgessBar
        
        viewToDraw.layer.addSublayer(baseLayer)
        viewToDraw.layer.addSublayer(percentageLayer)
        
        labelForText.text = "\(GlobalUtils.formatNumberToCurrency(value: amountSpent)) / \(String(format: "%.2f", (percentage * 100)) )%"
    }
    
    static func prepopulateCategoriesForExpense(with realm: Realm) {
        let categories = ["Food", "Entreteinment", "School", "Health", "Clothes", "Games"]
        
        for category in categories {
            MyRealmUtils.addOrUpdateCategoryForExpense(with: category, realm: realm)
        }
    }
    
    
}
