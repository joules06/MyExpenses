//
//  MonthGroupTableViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/5/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//
import Floaty
import RealmSwift
import UIKit


class MonthGroupTableViewController: UITableViewController {
    let realm = try! Realm()
    var monthItems : Results<Months>?
    var arrayOfMonth = [MonthForDisplay]()
    var selectedYear: Years? {
        didSet {
            loadData()
        }
    }
    
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
    
    var floaty = Floaty()
    
    let segueIdForNextAddScene = "goToAddMonth"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        setupFloatyButton()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let dataForYear = selectedYear {
            title = dataForYear.year
        }
        loadData()
        tableView.reloadData()
    }
    
    // MARK: - Funcionts for Realm
    func loadData() {
        monthItems = selectedYear?.months.sorted(byKeyPath: "month", ascending: true)
        arrayOfMonth = [MonthForDisplay]()
        
        for valueFromDictonary in GlobalVariables.monthsStringAndIntegers {
            
            var totalSpent = 0.0
            let predicate = NSPredicate(format: "month = %d", valueFromDictonary.key)
            let resultsForMonth = monthItems?.filter(predicate)
            
            
            let monthForDisplay = MonthForDisplay(monthInString: valueFromDictonary.value, monthInNumber: valueFromDictonary.key, totalSpent: 0.0, hasValue: false)
            
            if let monthInRealm = resultsForMonth {
                if monthInRealm.count > 0{
                    monthForDisplay.hasValue = true
                    
                    for index in 0...monthInRealm.count - 1{
                        totalSpent += monthInRealm[index].amountSpent
                    }
                    
                    monthForDisplay.totalSpent = totalSpent
                }
            }
            
            arrayOfMonth.append(monthForDisplay)
        }
        arrayOfMonth = arrayOfMonth.sorted(by: { $0.monthInNumber < $1.monthInNumber })
        
    }
    
    //MARK: - Floaty functions
    func setupFloatyButton() {
        let item = FloatyItem()
        item.hasShadow = false
        item.titleLabelPosition = .right
        item.title = "Nuevo gasto"
        item.icon = UIImage(named: "dollar")
        item.handler = { item in
            self.performSegue(withIdentifier: self.segueIdForNextAddScene, sender: self)
            self.floaty.close()
        }
        
        floaty.hasShadow = false
        
        floaty.addItem(item: item)
        //        floaty.paddingX = self.tableView.frame.width/2 - floaty.frame.width/2
        
        floaty.paddingX = self.view.frame.width/2 - floaty.frame.width/2
        floaty.sticky = true
        floaty.fabDelegate = self
        floaty.buttonColor = UIColor(hexString: GlobalVariables.hexForSecondColor)
        floaty.buttonImage = UIImage(named: "custom-add")
        floaty.items[0].titleLabelPosition = .right
        floaty.paddingY = 150
        
        //        self.tableView.addSubview(floaty)
        self.view.addSubview(floaty)
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueIdForNextAddScene:
            let destinationVC = segue.destination as! AddNewMonthViewController
            destinationVC.selectedYear = selectedYear
            break
        case "gotoMonthDetailsWithProgress":
            
            let destinationVC = segue.destination as! MonthDetailWithProgressViewController
            
            if let indexPath = tableView.indexPathForSelectedRow,
                let yearSelected = selectedYear?.year{
                
                let infoForNextController = YearAndMonth(year: yearSelected, month: arrayOfMonth[indexPath.row].monthInNumber, monthInString: arrayOfMonth[indexPath.row].monthInString)
                
                destinationVC.didSelectMonthAndYear = infoForNextController
            }
        default:
            fatalError("No valid identifier")
        }
        
    }
    
}

extension MonthGroupTableViewController: FloatyDelegate {
    
}
