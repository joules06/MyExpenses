//
//  ViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/4/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//
import ChameleonFramework
import Floaty
import RealmSwift
import SwipeCellKit
import UIKit


class YearsViewController: SwipeTableViewController, FloatyDelegate {
    @IBOutlet var myTableView: UITableView!
    
    var floaty = Floaty()
    let segueIdForNextDetailsScene = "goToMonths"
    let segueIdForNextAddScene = "goToNewYear"
    var yearsArray: Results<Years>?
    let realm = try! Realm()
    var spendFromYears: [Double] = [Double]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.rowHeight = 60
        
        setupFloatyButton()
        loadDataFromRealm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadDataFromRealm()
    }
    
    //MARK: - Table View Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdForNextDetailsScene, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdForNextDetailsScene{
            let destinationVC = segue.destination as! MonthGroupTableViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedYear = yearsArray?[indexPath.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yearsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! CustomYearTableViewCell
        guard let yearFromRealm = yearsArray?[indexPath.row] else {
            fatalError("Cannot get year")
        }
        
        let total = yearFromRealm.months.sum(ofProperty: "amountSpent") as Double
        
        
        cell.labelForExpense.text = GlobalUtils.formatNumberToCurrency(value: total)
        cell.labelForYearCell.text = yearFromRealm.year
        
        //setup for view
        cell.viewBehindYear.layer.borderWidth = 1
        
        let colors:[UIColor] = [
            UIColor(hexString: GlobalVariables.hexForSecondColor),
            UIColor(hexString: GlobalVariables.hexForThirdColor)
        ]
        
        cell.viewBehindYear.layer.borderColor = GradientColor(gradientStyle: .topToBottom, frame: cell.viewBehindYear.frame, colors: colors).cgColor
        
        cell.viewBehindYear.layer.cornerRadius = 20.0
        
        return cell
    }
    
    //MARK: - Floaty button
    func setupFloatyButton() {
        let item = FloatyItem()
        item.hasShadow = false
        item.titleLabelPosition = .right
        item.title = "New year"
        item.icon = UIImage(named: "calendar")
        item.handler = { item in
            self.performSegue(withIdentifier: self.segueIdForNextAddScene, sender: self)
            self.floaty.close()
        }
        
        floaty.hasShadow = false
        
        floaty.addItem(item: item)
        //floaty.paddingX = self.view.frame.width/2 - floaty.frame.width/2
        floaty.paddingX = self.tableView.frame.width/2 - floaty.frame.width/2
        floaty.sticky = true
        floaty.fabDelegate = self
        floaty.buttonColor = UIColor(hexString: GlobalVariables.hexForPrimaryColor)
        floaty.buttonImage = UIImage(named: "add")
        floaty.items[0].titleLabelPosition = .right
        
        floaty.paddingY =  120
        
        tableView.addSubview(floaty)
        
    }
    
    //MARK: - Realm methods
    func loadDataFromRealm() {
        yearsArray = realm.objects(Years.self).sorted(byKeyPath: "year", ascending: false)
        self.tableView.reloadData()
    }
    
    func saveDataToRealm(newYear: Years) {
        do{
            try realm.write {
                //realm.add(newYear, update: true)
                realm.add(newYear, update: .modified)
            }
        }catch{
            print("Error saving data to realm \(error)")
        }
        
        tableView.reloadData()
    }
    
    func fillArrayOfSpentFromYear() {
        spendFromYears.removeAll()
        var sum: Double = 0.0
        if let secureYearArray = yearsArray {
            for year in secureYearArray{
                sum = year.months.sum(ofProperty: "amountSpent") as Double
                
                spendFromYears.append(sum)
            }
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let year = yearsArray?[indexPath.row]{
            do {
                try realm.write {
                    realm.delete(year)
                }
            }catch {
                print("error deleting \(error)")
            }
            
        }
    }

}


extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
