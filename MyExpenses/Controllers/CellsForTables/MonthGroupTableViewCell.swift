//
//  MonthGroupTableViewCell.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/5/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import UIKit

class MonthGroupTableViewCell: UITableViewCell {
    @IBOutlet weak var labelForMonth: UILabel!
    @IBOutlet weak var labelForAmount: UILabel!
    @IBOutlet weak var imageBackgorund: UIImageView!
    @IBOutlet weak var parallaxImageHeight: NSLayoutConstraint!
    @IBOutlet weak var parallaxTopConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageBackgorund.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(month: String, amountSpent: String, image: UIImage?) {
        imageBackgorund.image = image
        labelForMonth.text = month
        labelForAmount.text = amountSpent
    }

}
