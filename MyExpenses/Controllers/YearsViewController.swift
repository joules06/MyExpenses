//
//  ViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/4/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//
import ChameleonFramework
import Floaty
import SwipeCellKit
import UIKit


class YearsViewController: SwipeTableViewController {
    @IBOutlet var myTableView: UITableView!
    
    let years: [Int] = [2018, 2019]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myTableView.rowHeight = 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMonths", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return years.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! CustomYearTableViewCell
        cell.labelForExpense.text = String(years[indexPath.row])
        
        //setup decorative form for year
        cell.viewBehindYear.layer.borderWidth = 1
        
        let colors:[UIColor] = [
            UIColor(hexString: GlobalVariables.hexForSecondColor),
            UIColor(hexString: GlobalVariables.hexForThirdColor)
        ]
        
        cell.viewBehindYear.layer.borderColor = GradientColor(gradientStyle: .topToBottom, frame: cell.viewBehindYear.frame, colors: colors).cgColor
        
        cell.viewBehindYear.layer.cornerRadius = 20.0
        
        return cell
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
