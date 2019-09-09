//
//  MonthCodable.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
class Monthscodable: Codable {
    var primaryKey: String
    var day, month: Int
    var monthForDisplay: String
    var amountSpent: Double
    var creditCardType, commets: String
    var categoryOfExpense: Int
    
    init(primaryKey: String, day: Int, month: Int, monthForDisplay: String, amountSpent: Double, creditCardType: String, commets: String, categoryOfExpense: Int) {
        self.primaryKey = primaryKey
        self.day = day
        self.month = month
        self.monthForDisplay = monthForDisplay
        self.amountSpent = amountSpent
        self.creditCardType = creditCardType
        self.commets = commets
        self.categoryOfExpense = categoryOfExpense
    }
}
