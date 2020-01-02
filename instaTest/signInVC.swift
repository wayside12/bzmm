//
//  signInVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 12/31/19.
//  Copyright © 2019 Back4App. All rights reserved.
//

import UIKit

class signInVC: UIViewController {

    @IBOutlet var usernameTxt: UITextField!
    
    @IBOutlet var passwordTxt: UITextField!
    
    @IBOutlet var signInBtn: UIButton!
    
    @IBOutlet var signUpBtn: UIButton!
    
    @IBOutlet var forgotBtn: UIButton!
    
    @IBAction func signInBtn_click(_ sender: Any) {
        
        print("sign in clicked!")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
