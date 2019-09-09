//
//  SaveDataRequest.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
class SaveDataRequest: Codable {
    let categories, years, months: String
    
    init(categories: String, years: String, months: String) {
        self.categories = categories
        self.years = years
        self.months = months
    }
}
