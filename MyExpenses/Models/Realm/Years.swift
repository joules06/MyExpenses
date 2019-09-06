//
//  Years.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/6/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
import RealmSwift

class Years: Object {
    @objc dynamic var year: String = ""
    @objc dynamic var maximumAmountToSpend: Double = 0.0
    let months = List<Months>()
    
    override static func primaryKey() -> String? {
        return "year"
    }
}
