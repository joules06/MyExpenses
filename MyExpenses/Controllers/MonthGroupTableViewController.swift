//
//  MonthGroupTableViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/5/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import UIKit

class MonthGroupTableViewController: UITableViewController {
    var arrayOfMonth = [MonthForDisplay]()
    
    let arrayOfImages = [
        UIImage(named: "january"),
        UIImage(named: "february"),
        UIImage(named: "march"),
        UIImage(named: "april"),
        UIImage(named: "may"),
        UIImage(named: "june"),
        UIImage(named: "july"),
        UIImage(named: "august"),
        UIImage(named: "september"),
        UIImage(named: "october"),
        UIImage(named: "november"),
        UIImage(named: "december"),
    ]
    
    let parallaxOffsetSpeed: CGFloat = 50
    let cellHeight: CGFloat = 250
    var paralllaxImageHeight: CGFloat {
        let maxOffset = (sqrt(pow(cellHeight, 2) + 4 * parallaxOffsetSpeed * tableView.frame.height) - cellHeight) / 2
        
        return maxOffset + cellHeight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.separatorStyle = .none
    }
    
    //MARK: - Data
    func loadData() {
        arrayOfMonth = [MonthForDisplay]()
        
        for valueFromDictonary in GlobalVariables.monthsStringAndIntegers {
             let monthForDisplay = MonthForDisplay(monthInString: valueFromDictonary.value, monthInNumber: valueFromDictonary.key, totalSpent: 0.0, hasValue: false)
            
            arrayOfMonth.append(monthForDisplay)
        }
        
        arrayOfMonth = arrayOfMonth.sorted(by: { $0.monthInNumber < $1.monthInNumber })
       
    }
    
    //MARK: - Functions for Parallax effect
    func parallaxOffset(newOffsetY: CGFloat, cell: UITableViewCell) -> CGFloat {
        return (newOffsetY - cell.frame.origin.y) / paralllaxImageHeight * parallaxOffsetSpeed
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in tableView.visibleCells as! [MonthGroupTableViewCell] {
            cell.parallaxTopConstraint.constant = parallaxOffset(newOffsetY: tableView.contentOffset.y, cell: cell)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfMonth.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthItemCell", for: indexPath) as! MonthGroupTableViewCell
        let monthInfo = arrayOfMonth[indexPath.row]
        var ammountForExpense = "$0.00"
        
        cell.labelForMonth.text = monthInfo.monthInString
        if monthInfo.hasValue {
            ammountForExpense = GlobalUtils.formatNumberToCurrency(value: monthInfo.totalSpent)
        }
        
        cell.setupCell(month: monthInfo.monthInString, amountSpent: ammountForExpense, image: arrayOfImages[indexPath.row])
        cell.parallaxImageHeight.constant = paralllaxImageHeight
        cell.parallaxTopConstraint.constant = parallaxOffset(newOffsetY: tableView.contentOffset.y, cell: cell)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoMonthDetailsWithProgress", sender: self)
    }
    

}
