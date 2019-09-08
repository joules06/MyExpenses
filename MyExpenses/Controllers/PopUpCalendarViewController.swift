//
//  PopUpCalendarViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/7/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import JTAppleCalendar
import RealmSwift
import UIKit

protocol getDateDelegate {
    func selectedDate(date: String, selected: Date)
}


class PopUpCalendarViewController: UIViewController {
    @IBOutlet weak var customCalendarView: JTAppleCalendarView!
    @IBOutlet weak var labelForYear: UILabel!
    @IBOutlet weak var labelForMonth: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var topStackView: UIStackView!
    
    let formatter = DateFormatter()
    let outsideMonthColor = UIColor(hexString: "ffffff")
    let monthColor = UIColor(hexString: GlobalVariables.hexForSecondColor)
    let selectedMonthColor = UIColor(hexString: GlobalVariables.hexForFourthColor)
    let realm = try! Realm()
    
    var selectedDateFromCalendar = Date()
    var selectedYear: Years?
    var monthItems : Results<Months>?
    
    var delegate: getDateDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMonthDetailsForYear()
        
        setupCalendarView()
        updateAppTheme()
        navigateToCurrentDateIfSelectedYearIsCurrentYear()
        doneButton.isEnabled = false
    }
    
    @IBAction func buttonSaveTapped(_ sender: UIButton) {
        self.delegate.selectedDate(date: "", selected: selectedDateFromCalendar)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonCancelTapped(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Functions to handle calendar
    func updateAppTheme() {
        let primaryColor = UIColor(hexString: GlobalVariables.hexForPrimaryColor)
        let selectedColor = primaryColor
        
        navigationController?.navigationBar.barTintColor = selectedColor
        guard let contrastingColor = UIColor(contrastingBlackOrWhiteColorOn:selectedColor, isFlat: true) else {
            return
        }
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : contrastingColor]
        doneButton.backgroundColor = selectedColor
        cancelButton.backgroundColor = selectedColor
        
        doneButton.tintColor = UIColor.white
        cancelButton.tintColor = UIColor.white
    }
    
    func setupCalendarView() {
        customCalendarView.minimumLineSpacing = 0
        customCalendarView.minimumInteritemSpacing = 0
        
        customCalendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCellForCalendar else{
            return
        }
        
        validCell.selctedView.isHidden = !cellState.isSelected
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCellForCalendar else {
            return
        }
        
        if cellState.isSelected {
            validCell.labelForDate.textColor = selectedMonthColor
        } else if cellState.dateBelongsTo == .thisMonth {
            validCell.labelForDate.textColor = monthColor
        } else {
            validCell.labelForDate.textColor = outsideMonthColor
        }
    }
    
    func isCurrentDateToday(dateFromCalendar: Date, view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCellForCalendar else {
            return
        }
        
        if let year = selectedYear {
            if year.year == String(GlobalUtils.getCurrentYear()) {
                let date = Date()
                let resultCompare = Calendar.current.compare(date, to: dateFromCalendar, toGranularity: .day)
                
                if resultCompare == .orderedSame && !cellState.isSelected {
                    validCell.viewForCurrentDate.isHidden = false
                    validCell.viewForCurrentDate.alpha = 0.5
                } else {
                    validCell.viewForCurrentDate.isHidden = true
                }
            }
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.labelForYear.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMM"
        self.labelForMonth.text = self.formatter.string(from: date)
    }
    
    func navigateToCurrentDateIfSelectedYearIsCurrentYear() {
        if let yearSelected = selectedYear {
            if yearSelected.year == String(GlobalUtils.getCurrentYear()) {
                let date = Date()
                
                customCalendarView.scrollToDate(date)
            }
        }
    }
    
    //MARK: - Realm Functions
    func isDateInRealm(with selectedDate: Date) -> Bool {
        let calendar = Calendar.current
        var exists = false
        
        let day = calendar.component(.day, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        
        let predicate = NSPredicate(format: "month = %d AND day = %d", month, day)
        let resultsForMonth = monthItems?.filter(predicate)
        
        if let count = resultsForMonth?.count {
            if count > 0{
                exists = true
            }
        }
        
        return exists
    }
    
    func getMonthDetailsForYear() {
        monthItems = selectedYear?.months.sorted(byKeyPath: "month", ascending: true)
    }
}

extension PopUpCalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let date = Date()
        let calendar = Calendar.current
        var year = calendar.component(.year, from: date)
        if let currentYear = selectedYear {
            if let currentYearInt =  Int(currentYear.year) {
                year = currentYearInt
            }
        }
        
        let startDate = formatter.date(from: "\(year) 01 01")!
        let endDate = formatter.date(from: "\(year) 12 31")!
        print("year \(year)")
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    
    
    func sharedFunctionToConfigureCell(myCustomCell: CustomCellForCalendar, cellState: CellState, date: Date?) {
        myCustomCell.labelForDate.text = cellState.text
        
    }
}

extension PopUpCalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CustomCellForCalendar
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: nil)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCellForCalendar
        
        sharedFunctionToConfigureCell(myCustomCell: cell, cellState: cellState, date: nil)
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        isCurrentDateToday(dateFromCalendar: date, view: cell, cellState: cellState)
        
        
        if isDateInRealm(with: date) {
            cell.dotViewForMark.isHidden = false
        } else {
            cell.dotViewForMark.isHidden = true
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        isCurrentDateToday(dateFromCalendar: date, view: cell, cellState: cellState)
        
        selectedDateFromCalendar = date
        doneButton.isEnabled = true
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        isCurrentDateToday(dateFromCalendar: date, view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }

}
