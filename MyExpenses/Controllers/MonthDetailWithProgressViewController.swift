//
//  MonthDetailWithProgressViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/5/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import ChameleonFramework
import RealmSwift
import SwipeCellKit
import UIKit

class MonthDetailWithProgressViewController: UIViewController {
    @IBOutlet weak var tableViewForData: UITableView!
    @IBOutlet weak var labelForPercentage: UILabel!
    @IBOutlet weak var viewForProgress: UIView!
    
    let array: [Double] = [10.5, 20.5, 30.0]
    
    let realm = try! Realm()
    var didSelectMonthAndYear: YearAndMonth?{
        didSet{
//            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewForData.rowHeight = 100
        
        if array.count == 0 {
            GlobalUtils.makeProgressBar(with: 50.0, maximunValue: getMaximunAmountForYear(month: nil), labelForText: labelForPercentage, viewToDraw: viewForProgress)
        }
    }
   
    
    //MARK: - Local functions
    func getMaximunAmountForYear(month: String?) -> Double {
//    func getMaximunAmountForYear(month: Months?) -> Double {
//        guard let safeMonth = month else {
//            return  GlobalVariables.budgetExpense
//        }
//
//        let predicate = NSPredicate(format: "ANY months.primaryKey = %@", safeMonth.primaryKey)
//
//        guard let object = realm.objects(Years.self).filter(predicate).first else {
//            return GlobalVariables.budgetExpense
//        }
//
//        return object.maximumAmountToSpend
        return 100.0
    }
    
    func makeProgressBar(){
//        guard let months = monthItems else{
//            return
//        }
//        var localTotalExpended = 0.0
//        for month in months{
//            localTotalExpended += month.amountSpent
//        }
        
//        GlobalUtils.makeProgressBar(with: localTotalExpended, maximunValue: getMaximunAmountForYear(month: months.first), labelForText: labelForPercentage, viewToDraw: viewForProgress)
        
        GlobalUtils.makeProgressBar(with: 50.0, maximunValue: 90.0, labelForText: labelForPercentage, viewToDraw: viewForProgress)
    }

}
extension MonthDetailWithProgressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForDetails", for: indexPath) as! CellForDataMonthTableViewCell
        cell.delegate = self
        
        cell.labelForDay.text = String(array[indexPath.row])
        
        let colors:[UIColor] = [
            UIColor(hexString: GlobalVariables.hexForSecondColor),
            UIColor(hexString: GlobalVariables.hexForThirdColor)
        ]
        
        cell.viewBehindDay.layer.borderWidth = 1
        cell.viewBehindDay.layer.borderColor = GradientColor(gradientStyle: .topToBottom, frame: cell.viewBehindDay.frame, colors: colors).cgColor
        
        cell.viewBehindDay.layer.cornerRadius = 20.0
        
        if array.count == (indexPath.row + 1){
            //update progress bar
//            GlobalUtils.makeProgressBar(with: totalExpended, maximunValue: getMaximunAmountForYear(month: monthInfoForRealm), labelForText: labelForPercentage, viewToDraw: viewForProgress)
            GlobalUtils.makeProgressBar(with: 60, maximunValue: 100, labelForText: labelForPercentage, viewToDraw: viewForProgress)
        }
        
        return cell
    }
    
}


extension MonthDetailWithProgressViewController: UITableViewDelegate {
    
}

extension MonthDetailWithProgressViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else{
            return nil
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.updateModel(at: indexPath)
            
        }
        
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath){
        //Update
//        if let monthInfoForRealm = monthItems?[indexPath.row]{
//            do{
//                try realm.write {
//                    realm.delete(monthInfoForRealm)
//                }
//            }catch {
//                print("error deleting month \(error)")
//            }
//
//            GlobalUtils.updateInternalVersionControlOnRealm(realm: realm)
//        }
        
        makeProgressBar()
    }
    
    
}
