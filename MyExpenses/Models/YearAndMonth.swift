//
//  YearAndMonth.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/6/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
class YearAndMonth {
    var year: String
    var month: Int
    var monthInString: String
    
    init(year: String, month: Int, monthInString: String) {
        self.year = year
        self.month = month
        self.monthInString = monthInString
    }
}
