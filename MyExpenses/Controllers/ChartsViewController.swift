//
//  ChartsViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Charts
import RealmSwift
import UIKit

class ChartsViewController: UIViewController, GetChartData, GetChartDataForPie, ChartViewDelegate {
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topPopUpConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelForSelectedDate: UILabel!
    @IBOutlet weak var buttonForPopu: UIButton!
    @IBOutlet weak var viewForPieChart: UIView!
    @IBOutlet weak var viewForLineChart: UIView!
    
    var xData =  [String]()
    var yData = [String]()
    var summaryForPieChart =  [(key: String, value: Double)]()
    var xDataPie = [String]()
    var yDataPie = [String]()
    
    var labelForData: String = ""
    let realm = try! Realm()
    
    var monthsSelected = true
    var menuVisible = false
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var monthsObjects = [MonthsWithData]()
    var years = ["2019", "2018", "2017", "2016"]
    let valueForHide: CGFloat = 100.0
    var valueForShow: CGFloat = 100.0
    let idTagForChartView = 10000
    let idTagForPieView = 100001
    
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    let itemsPerRow: CGFloat = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()

        valueForShow = topPopUpConstraint.constant
        collectionView.backgroundColor = UIColor(hexString: GlobalVariables.hexForFourthColor)
        
        populatePopUp()
        hideMenu()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        buttonForPopu.layer.zPosition = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        labelForSelectedDate.text = String(GlobalUtils.getCurrentYear())
        setUpChart(timeValue: String(GlobalUtils.getCurrentYear()), isTimeValueMonth: false)
        setUpPieChart(timeValue: String(GlobalUtils.getCurrentYear()), getDataForMonths: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        hideMenu()
        removePreviousChart(idForChart: idTagForChartView)
        removePreviousChart(idForChart: idTagForPieView)
    }
    @IBAction func configurationTapped(_ sender: UIButton) {
        if menuVisible {
            hideMenu()
        } else {
            openMenu()
        }
    }
    
   
    @IBAction func monthTapped(_ sender: UIButton) {
        monthsSelected = true
        hideAndShowViews()
    }
    
    
    @IBAction func yearsTapped(_ sender: UIButton) {
        monthsSelected = false
        hideAndShowViews()
    }
    
    //MARK: - Functions to get Data
    func getYearsInRealm() -> Results<Years> {
        return realm.objects(Years.self).sorted(byKeyPath: "year", ascending: false)
    }
    
    func populatePopUp() {
        populateYears()
        populateMonths()
    }
    
    func populateYears() {
        let yearsFromRealm = getYearsInRealm()
        
        if yearsFromRealm.count > 0 {
            years.removeAll()
            
            for yearInRealm in yearsFromRealm {
                years.append(yearInRealm.year)
            }
        }
    }
    
    func populateMonths() {
        //retrive data from realm
        let predicateForYear = NSPredicate(format: "year = %@", String(GlobalUtils.getCurrentYear()))
        
        let yearsResult = realm.objects(Years.self).filter(predicateForYear)
        
        //create data for x axis
        let sortedDictorinay = GlobalVariables.monthsStringAndIntegers.sorted { (key1, key2) -> Bool in
            if key1 < key2 {
                return true
            }else {
                return false
            }
        }
        
        monthsObjects.removeAll()
        
        for dictionaryEntry in sortedDictorinay {
            let index = dictionaryEntry.value.index(dictionaryEntry.value.startIndex, offsetBy: 3)
            let month = dictionaryEntry.value[..<index]
            
            let hasValue: Bool = populateYData(with: dictionaryEntry.key, realmYears: yearsResult, daySelected: 0) > 0 ? true : false
            let timeText = String(month)
            //now get data from Realm for months of selected year
            
            let timeEntry = MonthsWithData(month: timeText, hasValue: hasValue, monthInt: dictionaryEntry.key)
            
            monthsObjects.append(timeEntry)
        }
    }
    
    func setUpChart(timeValue: String, isTimeValueMonth: Bool) {
        var xValue: String = ""
        
        let yearToRetrieve: String = isTimeValueMonth ? String(GlobalUtils.getCurrentYear()) : timeValue
        
        //retrive data from realm
        let predicateForYear = NSPredicate(format: "year = %@", yearToRetrieve)
        
        let yearsResult = realm.objects(Years.self).filter(predicateForYear)
        
        //create data for x axis
        let dictionary = isTimeValueMonth ? GlobalUtils.createDaysForXAxisInCharts(month: timeValue, year: yearToRetrieve) : GlobalVariables.monthsStringAndIntegers
        
        let sortedDictorinay = dictionary.sorted { (key1, key2) -> Bool in
            if key1 < key2 {
                return true
            }else {
                return false
            }
        }
        
        xData.removeAll()
        yData.removeAll()
        
        for dictionaryEntry in sortedDictorinay {
            if isTimeValueMonth {
                xValue = String(dictionaryEntry.key)
                
            } else {
                let index = dictionaryEntry.value.index(dictionaryEntry.value.startIndex, offsetBy: 3)
                xValue = String(dictionaryEntry.value[..<index])
            }
            
            xData.append(xValue)
            
            let monthToGetData = isTimeValueMonth ? (Int(timeValue) ?? 0) : dictionaryEntry.key
            let dayToGetData = isTimeValueMonth ? (Int(dictionaryEntry.value) ?? 0) : 0
            
            _ = populateYData(with: monthToGetData, realmYears: yearsResult, daySelected: dayToGetData)
        }
        
        self.getChartData(with: xData, values: yData)
        
        addChartToView()
    }

    func populateYData(with monthSelected: Int, realmYears: Results<Years>, daySelected: Int) -> Double {
        var sumOfExpense = 0.0
        
        let predicate = NSPredicate(format: "month = %d", monthSelected)
        if let availableMonths = realmYears.first?.months.filter(predicate) {
            
            if daySelected == 0 {
                for element in availableMonths{
                    sumOfExpense += element.amountSpent
                }
            } else {
                let predicateForDay = NSPredicate(format: "day = %d", daySelected)
                let days = availableMonths.filter(predicateForDay)
                
                for element in days {
                    sumOfExpense += element.amountSpent
                }
            }
        }
        
        yData.append(String(sumOfExpense))
        
        return sumOfExpense
    }
    
    func setUpPieChart(timeValue: String, getDataForMonths: Bool) {
        var monthsForPieChart : Results<Months>?
        var summary =  [String: Double]()
        var predicate = NSPredicate()
        
        if getDataForMonths {
            //current time is month
            if let safeMonth = Int(timeValue) {
                predicate = NSPredicate(format: "ANY parentYear.year = %@ AND month = %d ", String(GlobalUtils.getCurrentYear()), safeMonth)
            }
            
        } else {
            predicate = NSPredicate(format: "year = %@", timeValue)
        }
        
        if getDataForMonths {
            monthsForPieChart = realm.objects(Months.self).filter(predicate)
        } else {
            let yearResults = realm.objects(Years.self).filter(predicate).first?.months
            //this is just to get a Results<Months>
            predicate = NSPredicate(format: "amountSpent > %f", 0.0)
            monthsForPieChart = yearResults?.filter(predicate)
        }
        
        
        if let safeMonths = monthsForPieChart {
            let distinctTypes = Set(safeMonths.value(forKey: "categoryOfExpense.primaryKey") as? [Int] ?? [-1])
            
            let totalSpent: Double = safeMonths.sum(ofProperty: "amountSpent")
            
            for distinctType in distinctTypes {
                let predicate = NSPredicate(format: "categoryOfExpense.primaryKey = %d", distinctType)
                let results = safeMonths.filter(predicate)
                var amount: Double = 0
                
                for month in results {
                    amount += month.amountSpent
                }
                
                if let name =  results.first?.categoryOfExpense?.name {
                    summary[name] = amount
                }
            }
            
            summaryForPieChart = summary.sorted(by: {$0.value > $1.value})
            createArrayOfValuesForPieChart(totalSpent: totalSpent)
            self.getChartDataForPieChart(with: xDataPie, values: yDataPie)
            addPieChartToView()
        }
        
    }
    
    func createArrayOfValuesForPieChart(totalSpent: Double) {
        xDataPie.removeAll()
        yDataPie.removeAll()
        
        var count = 1
        let moreThan4: Bool = summaryForPieChart.count > 4 ? true : false
        var fourthValue: Double = 0.0
        
        for element in summaryForPieChart {
            if moreThan4 && count > 3 {
                fourthValue += element.value
            } else {
                xDataPie.append(element.key)
                
                yDataPie.append(String(element.value / totalSpent))
            }
            count += 1
        }
        
        if moreThan4 {
            xDataPie.append("Others")
            yDataPie.append(String(fourthValue / totalSpent))
        }
        
    }
    
    //MARK: - Chart Functions
    func addChartToView() {
        removePreviousChart(idForChart: idTagForChartView)
        let barChart = Barchart(frame: CGRect(x: 0.0, y: 0.0, width: viewForLineChart.frame.width, height: viewForLineChart.frame.height))
        
        barChart.delegate = self
        barChart.tag = idTagForChartView
        viewForLineChart.addSubview(barChart)
    }
    
    func addPieChartToView() {
        removePreviousChart(idForChart: idTagForPieView)
        let pieChartObject = Piechart(frame: CGRect(x: 0.0, y: 0.0 , width: viewForPieChart.frame.width, height: viewForPieChart.frame.height))
        
        pieChartObject.delegate = self
        pieChartObject.tag = idTagForPieView
        
        viewForPieChart.addSubview(pieChartObject)
    }
    
    func removePreviousChart(idForChart: Int) {
        if let viewWithTag = self.view.viewWithTag(idForChart) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func getChartData(with dataPoints: [String], values: [String]) {
        self.xData = dataPoints
        self.yData = values
        self.labelForData = "Expenses"
    }
    
    func getChartDataForPieChart(with dataPoints: [String], values: [String]) {
        self.xDataPie = dataPoints
        self.yDataPie = values
        self.labelForData = "Categories"
    }
    
    //MARK: - Functions for show and hide Pop up
    func hideAndShowViews() {
        collectionView.reloadData()
    }
    
    func openMenu() {
        // when menu is opened, it's left constraint should be 0
        topPopUpConstraint.constant = valueForShow
        
        // view for dimming effect should also be shown
        popUpView.isHidden = false
        
        // animate opening of the menu - including opacity value
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.popUpView.alpha = 100
        }, completion: { (complete) in
            
        })
        
        menuVisible = true
    }
    
    func hideMenu() {
        // when menu is closed, it's left constraint should be of value that allows it to be completely hidden to the left of the screen - which is negative value of it's width
        topPopUpConstraint.constant = -valueForHide
        
        // animate closing of the menu - including opacity value
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.popUpView.alpha = 0
        }, completion: { (complete) in
            
            // hide the view for dimming effect so it wont interrupt touches for views underneath it
            self.popUpView.isHidden = true
        })
        
        menuVisible = false
    }

}


public class ChartFormatter: NSObject, IAxisValueFormatter {
    var valuesForChart = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return valuesForChart[Int(value)]
    }
    
    public func setValues(values: [String]) {
        self.valuesForChart = values
    }
}

//MARK: - Collection View Delegate
extension ChartsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        var section = ""
        var textForLabel = ""
        var enabled = true
        if monthsSelected {
            if indexPath.row < monthsObjects.count{
                section = String(monthsObjects[indexPath.row].monthInt)
                enabled = monthsObjects[indexPath.row].hasValue
                textForLabel = "\(monthsObjects[indexPath.row].month) (\(GlobalUtils.getCurrentYear()))"
            }
        } else{
            if indexPath.row < years.count {
                section = years[indexPath.row]
                textForLabel = section
            }
        }
        if enabled{
            hideMenu()
            
            setUpChart(timeValue: section, isTimeValueMonth: monthsSelected)
            setUpPieChart(timeValue: section, getDataForMonths: monthsSelected)
            
            labelForSelectedDate.text = "\(textForLabel)"
            
        }
        
    }
}
//MARK: - Collection View DataSource delegate
extension ChartsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if monthsSelected {
            return monthsObjects.count
        } else {
            return years.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCollectionViewCell", for: indexPath) as! TimeCollectionViewCell
        
        var subString = ""
        var color = UIColor.init(hexString: GlobalVariables.hexForSecondColor)
        
        if monthsSelected {
            let month = monthsObjects[indexPath.row]
            let index = month.month.index(month.month.startIndex, offsetBy: 3)
            subString = String(months[indexPath.row][..<index])
            
            if !month.hasValue {
                color = UIColor.gray
            }
            
        } else {
            subString = years[indexPath.row]
        }
        
        
        cell.labelForTime.text = subString
        cell.labelForTime.tag = indexPath.row
        cell.tag = indexPath.row
        cell.labelForTime.textColor = color
        
        return cell
    }
    
}

extension ChartsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
