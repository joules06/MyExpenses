//
//  GlobalUtils.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/5/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation

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
}
