//
//  YearsCodable.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation

class YearsCodable: Codable {
    let year: String
    let maximumAmountToSpend: Double
    let monthscodable: [Monthscodable]
    
    
    
    init(year: String, maximumAmountToSpend: Double, monthscodable: [Monthscodable]) {
        self.year = year
        self.maximumAmountToSpend = maximumAmountToSpend
        self.monthscodable = monthscodable
    }
}
