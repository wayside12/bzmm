//
//  navVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/20/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit

class navVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //color of title at the top of navigation controller
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        //color of button in nav navcontroller
        self.navigationBar.tintColor = .white
        
        //color of background of nav controller
        self.navigationBar.barTintColor = UIColor(red: 18.0/255.0, green: 86.0/255.0, blue: 136.0/255.0, alpha: 1)
        
        //unable translucent
        self.navigationBar.isTranslucent = false
        
    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }


}
