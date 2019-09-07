//
//  MyRealmUtils.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/6/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
import RealmSwift

class MyRealmUtils {
    static func addOrUpdateCategoryForExpense(with categoryName: String, realm: Realm) {
        let maxValue = getMaxValueForPrimaryKeyFromCategory(realm: realm)
        
        let category = CategoryForExpense()
        category.name = categoryName
        category.primaryKey = maxValue + 1
        
        try! realm.write {
            realm.create(CategoryForExpense.self, value: category, update: .modified)
        }
    }
    
    static func addOrUpdateVariableForConfiguration(with id: Int, value: String, realm: Realm) {
        let configuration = ConfigurationApp()
        
        configuration.primaryKey = id
        configuration.value = value
        
        try! realm.write {
            realm.create(ConfigurationApp.self, value: configuration, update: .modified)
        }
    }
    
    static func getConfigurationVariable(with realm: Realm, id: Int) -> Results<ConfigurationApp> {
        let predicate = NSPredicate(format: "primaryKey = %d", id)
        
        let results = realm.objects(ConfigurationApp.self).filter(predicate)
        
        return results
    }
    
    static public func getMaxValueForPrimaryKeyFromCategory(realm: Realm) -> Int{
        var maxValue = 0
        
        guard let max = realm.objects(CategoryForExpense.self).max(ofProperty: "primaryKey") as Int? else{
            return 0
        }
        
        maxValue = max
        
        return maxValue
    }
    
}

