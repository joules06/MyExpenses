//
//  MonthForDisplay.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/5/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation

class MonthForDisplay {
    let monthInString: String
    let monthInNumber: Int
    var totalSpent: Double
    var hasValue: Bool
    
    init(monthInString: String, monthInNumber: Int, totalSpent: Double, hasValue: Bool){
        self.monthInNumber = monthInNumber
        self.monthInString = monthInString
        self.totalSpent = totalSpent
        self.hasValue = hasValue
    }
}
