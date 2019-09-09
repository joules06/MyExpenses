//
//  LastUpdateControl.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
import RealmSwift

class LastUpdateControl: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var lastUpdate: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
