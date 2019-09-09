//
//  UserSession.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
import RealmSwift

class UserSession: Object {
    @objc dynamic var primaryKey: Int = 0
    @objc dynamic var session: String = ""
    
    override static func primaryKey() -> String? {
        return "primaryKey"
    }
}
