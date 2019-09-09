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
    func updateVersionCodeToRealm(newVersionCode: Int, realm: Realm) {
        let versionCode = VersionCode()
        
        versionCode.id = "1"
        versionCode.versionCode = newVersionCode
        
        do {
            try realm.write {
                //realm.add(versionCode, update: true)
                realm.add(versionCode, update: .modified)
            }
        }catch {
            print("Error adding ticks \(error)")
        }
        
        addOrUpdateLasUpdateString(realm: realm)
    }
    
    private func addOrUpdateLasUpdateString(realm: Realm) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy, h:mm a"
        
        
        let lastUpdateInRealm = LastUpdateControl()
        
        lastUpdateInRealm.id = "1"
        lastUpdateInRealm.lastUpdate = formatter.string(from: date)
        
        do {
            try realm.write {
                realm.create(LastUpdateControl.self, value: lastUpdateInRealm, update: .modified)
            }
        } catch {
            print("Error adding last update to realm \(error)")
        }
    }
    
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
    
    static public func saveSessionForUser(with realm: Realm, session: String) {
        let userSession = UserSession()
        
        userSession.primaryKey = 1
        userSession.session = session
        
        do {
            try realm.write {
                realm.create(UserSession.self, value: userSession, update: .modified)
            }
        } catch {
            fatalError("Could not save session data")
        }
    }
    
    static public func getUserSession(with realm: Realm) -> String? {
        let predicate = NSPredicate(format: "primaryKey = %d", 1)
        
        let results = realm.objects(UserSession.self).filter(predicate)
        
        return results.first?.session
    }
    
    static func getLasStringForUpdateInRealm(realm: Realm) -> String? {
        let predicate = NSPredicate(format: "id = %@", "1")
        
        guard let object = realm.objects(LastUpdateControl.self).filter(predicate).first else {
            return nil
        }
        
        return object.lastUpdate
    }
    
    static func getVersionCodeFromRealm(realm: Realm) -> Int? {
        let predicate = NSPredicate(format: "id = %@", "1")
        let objects = realm.objects(VersionCode.self).filter(predicate)
        
        if let firstObject = objects.first {
            return firstObject.versionCode
        } else {
            return nil
        }
    }
    
    static func updateCategories(newCategories: [CategoryForExpense], realm: Realm) {
        for category in newCategories {
            do {
                try realm.write {
                    realm.add(category, update: .modified)
                }
            } catch {
                fatalError("Error updating categories \(error)")
            }
        }
    }
    
    static func updateYearsAndMonths(newYearsAndMonths: [YearsCodable], realm: Realm) {
        var canContinue: Bool = true
        var predicate = NSPredicate()
        let allYears = realm.objects(Years.self)
        
        do {
            try realm.write {
                realm.delete(allYears)
            }
        } catch {
            canContinue = false
        }
        
        if canContinue {
            let allMonths = realm.objects(Months.self)
            
            do {
                try realm.write {
                    realm.delete(allMonths)
                }
            }catch {
                canContinue = false
            }
        }
        
        
        if canContinue {
            for yearAndMonth in newYearsAndMonths {
                let year = Years()
                
                year.year = yearAndMonth.year
                year.maximumAmountToSpend = yearAndMonth.maximumAmountToSpend
                
                do {
                    try realm.write {
                        realm.add(year, update: .modified)
                    }
                }catch {
                    canContinue = false
                }
                
                if canContinue {
                    for monthCodable in yearAndMonth.monthscodable {
                        let month = Months()
                        
                        month.amountSpent = monthCodable.amountSpent
                        month.commets = monthCodable.commets
                        month.creditCardType = monthCodable.creditCardType
                        month.day = monthCodable.day
                        month.month = monthCodable.month
                        month.monthForDisplay = monthCodable.monthForDisplay
                        
                        predicate = NSPredicate(format: "primaryKey = %d", monthCodable.categoryOfExpense)
                        if let categoryForExpense = realm.objects(CategoryForExpense.self).filter(predicate).first {
                            month.categoryOfExpense = categoryForExpense
                        }
                        
                        do {
                            try realm.write {
                                year.months.append(month)
                            }
                        }catch {
                            fatalError("Error adding months \(error)")
                        }
                    }
                }
            }
        }
        print("done")
    }
    
}

