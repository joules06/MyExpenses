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
    let formatter = DateFormatter()
    let outsideMonthColor = UIColor(hexString: "ffffff")
    let monthColor = UIColor(hexString: GlobalVariables.hexForSecondColor)
    let selectedMonthColor = UIColor(hexString: GlobalVariables.hexForThirdColor)
    let realm = try! Realm()
    
    var selectedDateFromCalendar = Date()
    var selectedYear: Years?
    var monthItems : Results<Months>?
    
    var delegate: getDateDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
