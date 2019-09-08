//
//  CustomCellForCalendar.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/7/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//
import JTAppleCalendar
import UIKit

class CustomCellForCalendar: JTAppleCell {
    @IBOutlet weak var labelForDate: UILabel!
    @IBOutlet weak var selctedView: UIView!
    @IBOutlet weak var dotViewForMark: UIView!
    @IBOutlet weak var viewForCurrentDate: UIView!
}
