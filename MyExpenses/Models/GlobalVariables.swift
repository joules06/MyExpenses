//
//  GlobalVariables.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/5/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
import UIKit

class GlobalVariables {
    static let hexForPrimaryColor = "97de95"   //green light
    static let hexForSecondColor = "571179"   //purple
    static let hexForThirdColor = "08c299"   //green - dark
    static let hexForFourthColor = "fce8aa"  //yellow
    static let budgetExpense = 200.0
    static var heightForTabBar: CGFloat = 0.0
    static let baseURL: String =  "http://190.5.138.34:3434/expenses/api/"
    static let urlToSave: String = baseURL + "Expenses/?device="
    static let sessionURL: String = baseURL + "login"
    static let newUserURL: String = baseURL + "new-user"
//    static let urlToSave: String = "http://190.5.138.34:3434/expenses/api/Expenses/?device="
    
    static let formatStringForDate: String = "yyyyMMdd HH:mm:ss"
    
    static let monthsStringAndIntegers: [Int: String] = [1: "January", 2: "February", 3: "March", 4: "April", 5: "May",
                                                         6: "June", 7: "July", 8: "August", 9: "September",
                                                         10: "October", 11: "November", 12: "December"]
    
}


enum DownloadUploadData {
    case UploadData
    case DonwloadData
}
