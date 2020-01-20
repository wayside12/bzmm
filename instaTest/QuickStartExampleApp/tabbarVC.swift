//
//  tabbarVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/20/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit

class tabbarVC: UITabBarController {

    //default function
    override func viewDidLoad() {
        super.viewDidLoad()

        //color of item
        self.tabBar.tintColor = .white
        
        //color of background
        self.tabBar.barTintColor = UIColor(red: 37.0/255.0, green: 39.0/255.0, blue: 42.0/255.0, alpha: 1)
        
        //disable translucent
        self.tabBar.isTranslucent = false
        
    }
    

}
