//
//  GlobalUtils.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/5/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//
import ChameleonFramework
import RealmSwift
import Foundation
import UIKit

class GlobalUtils {
    static func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        guard let userInfo = notification.userInfo else { return 0.0 }
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return 0.0 }
        
        return keyboardSize.cgRectValue.height
    }
    
    static func getCurrentYear() -> Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    
    static func addIconToTextField(textField: UITextField, imageName: String, isLeft: Bool) {
        let heightImage = 20
        let widthImage = 20
        
        let imageView = UIImageView()
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.frame = CGRect(x: 5, y: 5, width: widthImage, height: heightImage)
        if isLeft {
            textField.leftView = imageView
            textField.leftViewMode = .always
        } else {
            textField.rightView = imageView
            textField.rightViewMode = .always
        }
    }
    
    static func formatNumberToCurrency(value: Double) -> String {
        var valueAsCurrency: String = ""
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        if let valueFormatted = formatter.string(from: value as NSNumber) {
            valueAsCurrency = valueFormatted
        } else {
            valueAsCurrency = String(format: "%.2f", value)
        }
        
        return valueAsCurrency
    }
    
    static func changeHeightForTextField(textField: UITextField, desiredHeight: CGFloat) {
        var frameRectangular = textField.frame
        frameRectangular.size.height = desiredHeight
        textField.frame = frameRectangular
    }
    
    static func addBottomBorderToTextField(textField: UITextField) {
        let border = CALayer()
        let widthForBorder = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        
        border.frame = CGRect(x: 0, y: textField.frame.size.height - widthForBorder, width: textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = widthForBorder
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    static func makeProgressBar(with amountSpent: Double, maximunValue: Double, labelForText: UILabel, viewToDraw: UIView){
        
        let width = viewToDraw.frame.width - 20
        var progressWidht = maximunValue >= 0 ? amountSpent * Double(width) / maximunValue : 0
        var cgColorForProgessBar : CGColor
        let percentage = maximunValue >= 0 ? amountSpent / maximunValue : 0
        
        
        if percentage > 0 && percentage <= 0.20{
            cgColorForProgessBar = UIColor(hexString: GlobalVariables.hexForPrimaryColor).cgColor
        } else if percentage > 0.20  && percentage <= 0.60 {
            cgColorForProgessBar = UIColor.flatLime()?.cgColor ?? UIColor.orange.cgColor
        } else if percentage > 0.60 && percentage <= 0.70 {
            cgColorForProgessBar = UIColor.flatYellow()?.cgColor ?? UIColor.yellow.cgColor
        } else if percentage > 0.70 && percentage <= 0.80 {
            cgColorForProgessBar = UIColor.flatLime()?.cgColor ?? UIColor.red.cgColor
        } else {
            cgColorForProgessBar = UIColor.flatRedColorDark()?.cgColor ?? UIColor.brown.cgColor
        }
        
        if amountSpent >= maximunValue {
            progressWidht = Double(width)
        }
        
        let baseLayer = CAShapeLayer()
        baseLayer.path = UIBezierPath(roundedRect: CGRect(x: 10, y: 0, width: width, height: 10), cornerRadius: 50).cgPath
        baseLayer.fillColor = UIColor.gray.cgColor
        
        let percentageLayer = CAShapeLayer()
        percentageLayer.path = UIBezierPath(roundedRect: CGRect(x: 10, y: 0, width: CGFloat(progressWidht), height: 10), cornerRadius: 50).cgPath
        percentageLayer.fillColor = cgColorForProgessBar
        
        viewToDraw.layer.addSublayer(baseLayer)
        viewToDraw.layer.addSublayer(percentageLayer)
        
        labelForText.text = "\(GlobalUtils.formatNumberToCurrency(value: amountSpent)) / \(String(format: "%.2f", (percentage * 100)) )%"
    }
    
    static func prepopulateCategoriesForExpense(with realm: Realm) {
        let categories = ["Food", "Entreteinment", "School", "Health", "Clothes", "Games"]
        
        for category in categories {
            MyRealmUtils.addOrUpdateCategoryForExpense(with: category, realm: realm)
        }
    }
    
    static func updateNavBar(withHexCode colourHexString: String, navigationController: UINavigationController?) {
        guard let navBar = navigationController?.navigationBar else {
            return
        }
        
        let navBarColour = UIColor(hexString: colourHexString)
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(backgroundColor: navBarColour, returnFlat: true)
        
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.flatWhite()!]
        
    }
    
    static func createDaysForXAxisInCharts(month: String, year: String) -> [Int: String] {
        var daysDictionary = [Int: String]()
        
        if let monthInt = Int(month),
            let yearMonth = Int(year) {
            let numberOfDays = getNumberOfDays(month: monthInt, year: yearMonth)
            
            for i in stride(from: 1, through: numberOfDays, by: 1) {
                daysDictionary[i] = String(i)
                
            }
        }
        
        return daysDictionary
    }
    
    fileprivate static func getNumberOfDays(month:Int, year: Int) -> Int {
        var numberOfDays = -1
        let dateComponentes = DateComponents(year: year, month: month)
        
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponentes),
            let range = calendar.range(of: .day, in: .month, for: date) {
            numberOfDays = range.count
        }
        
        return numberOfDays
    }
    
    static func getBundleVersion() -> String? {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return nil
        }
        
        return appVersion
    }
    
    static func compareVersionCode(realm: Realm, dataFromRequest: Data?) -> (String, Int) {
        //make request
        //serialize response
        //compare current time to ticks
        var responseObject: CompareVersionCodeResponse?
        var message: String = ""
        var difference: Int = 0
        
        if let data = dataFromRequest {
            do {
                responseObject = CompareVersionCodeResponse(differenceBetweenVersionCode: 0, responseCode: "200", responseStatus: "OK")
                responseObject = try JSONDecoder().decode(CompareVersionCodeResponse.self, from: data)
                
                if let object = responseObject {
                    
//                    switch object.differenceBetweenVersionCode {
//                    case 0:
//                        message = "Data checked"
//                    case _ where object.differenceBetweenVersionCode < 0:
//                        message = "Data from server is not updated"
//                    default:
//                        message = "New data version"
//                    }
                    message = "Data checked"
                    
                    difference = object.differenceBetweenVersionCode
                }
                
            }catch {
                print("error unserialize \(error)")
            }
            
        }
        
        return (message, difference)
    }
    
    static func convertFromRealmToJson(realm: Realm) -> [String:Any]? {
        var yearsJson = [YearsCodable]()
        var categoriesString = ""
        var yearsString = ""
        var dictFromJSON: [String:Any] = [String:Any]()
        
        let categories = realm.objects(CategoryForExpense.self)
        let array = Array(categories)
        let encodedCategoriesObject = try? JSONEncoder().encode(array)
        if let encodedObjectJsonCategoriesString = String(data: encodedCategoriesObject!, encoding: .utf8)
        {
            categoriesString = encodedObjectJsonCategoriesString
        }
        
        let years = realm.objects(Years.self)
        
        for yearRealm in years {
            var monthCodableArray = [Monthscodable]()
            
            
            for monthRealm in yearRealm.months {
                let monthCodable = Monthscodable(primaryKey: "", day: 0, month: 0, monthForDisplay: "", amountSpent: 0.0, creditCardType: "", commets: "", categoryOfExpense: 0)
                
                monthCodable.primaryKey = monthRealm.primaryKey
                monthCodable.day = monthRealm.day
                monthCodable.month = monthRealm.month
                monthCodable.monthForDisplay = monthRealm.monthForDisplay
                monthCodable.amountSpent = monthRealm.amountSpent
                monthCodable.creditCardType = monthRealm.creditCardType
                monthCodable.commets = monthRealm.commets
                
                if let category = monthRealm.categoryOfExpense {
                    monthCodable.categoryOfExpense = category.primaryKey
                }
                
                monthCodableArray.append(monthCodable)
            }
            
            let yearCodable = YearsCodable(year: yearRealm.year, maximumAmountToSpend: yearRealm.maximumAmountToSpend, monthscodable: monthCodableArray)
            
            yearsJson.append(yearCodable)
        }
        
        let encodedYears = try? JSONEncoder().encode(yearsJson)
        if let encodedYearsObjectJsonString = String(data: encodedYears!, encoding: .utf8) {
            yearsString = encodedYearsObjectJsonString
        }
        
        let savedModel = SaveDataRequest(categories: categoriesString, years: yearsString, months: "Months")
        
        //convert object to Data
        let encodedObject = try? JSONEncoder().encode(savedModel)
        if let safeDecodedObject = encodedObject {
            do {
                let decoded = try JSONSerialization.jsonObject(with: safeDecodedObject, options: [])
                
                //convert to dictionary
                if let safeDictionary = decoded as? [String:Any] {
                    dictFromJSON = [String:Any]()
                    dictFromJSON = safeDictionary
                }
            } catch {
                fatalError("Error serializing categories and years")
            }
            
        }
        
        return dictFromJSON
    }
    
    static func convertFromJsonToReam(realm: Realm, data: Data?) {
        var responseObject: GetDataForUpdateRequest?
        var categoriesFromJson: [CategoryForExpense]?
        
        if let safeData = data {
            do {
                responseObject = GetDataForUpdateRequest(categories: "", years: "", months: "", versionControl: "", responseCode: "", responseStatus: "")
                responseObject = try JSONDecoder().decode(GetDataForUpdateRequest.self, from: safeData)
                
                
                if let object = responseObject {
                    if object.responseCode == "200" && object.responseStatus == "OK" {
                        if let dataForYears = object.years.data(using: .utf8),
                            let dataForCategories = object.categories.data(using: .utf8) {
                            let yearsCodable = try JSONDecoder().decode([YearsCodable].self, from: dataForYears)
                            
                            categoriesFromJson = [CategoryForExpense]()
                            categoriesFromJson = try JSONDecoder().decode([CategoryForExpense].self, from: dataForCategories)
                            
                            if let safeCategories = categoriesFromJson {
                                MyRealmUtils.updateCategories(newCategories: safeCategories, realm: realm)
                            }
                            
                            MyRealmUtils.updateYearsAndMonths(newYearsAndMonths: yearsCodable, realm: realm)
                            
                            if let versionControl = Int(object.versionControl) {
                                let realmUtils = MyRealmUtils()
                                realmUtils.updateVersionCodeToRealm(newVersionCode: versionControl, realm: realm)
                            }
                        }
                    }
                }
                
            } catch {
                print("error unserialize \(error)")
            }
            
        }
    }
}
