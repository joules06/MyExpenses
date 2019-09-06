//
//  Months.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/6/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
import RealmSwift

class Months: Object {
    @objc dynamic var primaryKey: String = UUID().uuidString
    @objc dynamic var day: Int = 0
    @objc dynamic var month: Int = 0
    @objc dynamic var monthForDisplay: String = ""
    @objc dynamic var amountSpent: Double = 0.0
    @objc dynamic var creditCardType: String = ""
    @objc dynamic var commets: String = ""
    @objc dynamic var categoryOfExpense: CategoryForExpense?
    var parentYear = LinkingObjects(fromType: Years.self, property: "months")
    
    override static func primaryKey() -> String? {
        return "primaryKey"
    }
    
}
