//
//  Configuration.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/6/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
import RealmSwift


class ConfigurationApp: Object {
    @objc dynamic var primaryKey: Int = 0
    @objc dynamic var value: String = ""
    
    override static func primaryKey() -> String? {
        return "primaryKey"
    }
}

