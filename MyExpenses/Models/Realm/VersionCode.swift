//
//  VersionCode.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
import RealmSwift

class VersionCode: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var versionCode: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

