//
//  GlobalUtils.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/5/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
import UIKit

class GlobalUtils {
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
    
    static func makeProgressBar(with amountSpent: Double, maximunValue: Double, labelForText: UILabel, viewToDraw: UIView){
        
        let width = viewToDraw.frame.width - 20
        var progressWidht = maximunValue >= 0 ? amountSpent * Double(width) / maximunValue : 0
        var cgColorForProgessBar : CGColor
        let percentage = maximunValue >= 0 ? amountSpent / maximunValue : 0
        
        
        if percentage > 0 && percentage <= 0.20{
            cgColorForProgessBar = UIColor(hexString: GlobalVariables.hexForPrimaryColor).cgColor
        } else if percentage > 0.20  && percentage <= 0.60{
            cgColorForProgessBar = UIColor.flatLime()?.cgColor ?? UIColor.orange.cgColor
        } else if percentage > 0.60 && percentage <= 0.70{
            cgColorForProgessBar = UIColor.flatYellow()?.cgColor ?? UIColor.yellow.cgColor
        } else if percentage > 0.70 && percentage <= 0.80{
            cgColorForProgessBar = UIColor.flatLime()?.cgColor ?? UIColor.red.cgColor
        } else{
            cgColorForProgessBar = UIColor.flatRedColorDark()?.cgColor ?? UIColor.brown.cgColor
        }
        
        if amountSpent >= maximunValue{
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
}
