//
//  TabBarViewController.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/10/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    @IBOutlet weak var myCustomTabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTabBar()
    }
    

    func setUpTabBar(){
        if let allItems = myCustomTabBar.items{
            var index = 1
            var title = ""
            var imageName = ""
            for element in allItems{
                switch index{
                case 1:
                    title = "Expenses"
                    imageName =  "todo-list_24"
                    
                case 2:
                    title = "Charts"
                    imageName =  "charts-24"
                    
                case 3:
                    title = "Configuration"
                    imageName =  "sync_24"
                    
                default:
                    title = "Expenses"
                    imageName =  "todo-list_24"
                }
                index += 1
                
                element.title = title
                element.image = UIImage(named: imageName)
                
                
            }
        }
        
        
    }

}
