//
//  MonthsWithData.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
class MonthsWithData {
    
    var month: String
    var monthInt: Int
    var hasValue: Bool
    
    init(month: String, hasValue: Bool, monthInt: Int) {
        self.month = month
        self.hasValue = hasValue
        self.monthInt = monthInt
    }
}
