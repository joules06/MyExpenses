//
//  CategoryForExpense.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/6/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
import RealmSwift


class CategoryForExpense: Object, Codable {
    @objc dynamic var primaryKey: Int = 0
    @objc dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "primaryKey"
    }
    
    convenience init(primaryKey: Int, name: String) {
        self.init()
        self.primaryKey = primaryKey
        self.name = name
    }
}
