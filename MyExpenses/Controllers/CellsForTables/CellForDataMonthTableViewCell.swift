//
//  CellForDataMonthTableViewCell.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/5/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
import SwipeCellKit

class CellForDataMonthTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var labelForDay: UILabel!
    @IBOutlet weak var labelForExpense: UILabel!
    @IBOutlet weak var labelForCreditCard: UILabel!
    @IBOutlet weak var labelForDescription: UILabel!
    @IBOutlet weak var viewBehindDay: UIView!
    @IBOutlet weak var labelForCategory: UILabel!
    
    
}
