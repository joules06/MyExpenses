//
//  ViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/4/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//
import Floaty
import SwipeCellKit
import UIKit


class YearsViewController: SwipeTableViewController {
    @IBOutlet var myTableView: UITableView!
    
    let years: [Int] = [2018, 2019]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return years.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! CustomYearTableViewCell
        cell.labelForExpense.text = String(years[indexPath.row])
        return cell
    }

}


