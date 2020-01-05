//
//  resetPasswordVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 12/31/19.
//  Copyright © 2019 Back4App. All rights reserved.
//

import UIKit
import Parse
class resetPasswordVC: UIViewController {

   
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var resetBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    @IBAction func resetBtn_click(_ sender: Any) {
        
        //hide keyboard
        self.view.endEditing(true)
        
        //if email is empty
        if emailTxt.text!.isEmpty {
            
            //show alert message
            let alert = UIAlertController(title: "Please", message: "fill in email", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        // reset password request
        PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success:Bool, error:Error?) in
            //show alert message
            let alert = UIAlertController(title: "Email for resetting password", message: "has been sent to texted email", preferredStyle: UIAlertController.Style.alert)
            
            //if ok pressed, run self.dismiss function
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancelBtn_click(_ sender: Any) {
        
        //hide keyboard when pressed cancel
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTxt.frame = CGRect(x: 10, y: 120, width: self.view.frame.size.width - 20, height: 30)
        resetBtn.frame = CGRect(x: 20, y: emailTxt.frame.origin.y + 50, width: self.view.frame.size.width/4, height: 30)
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width/4 - 20, y: resetBtn.frame.origin.y, width: self.view.frame.size.width/4, height: 30)
        
        // Do any additional setup after loading the view.
    }
    

    

}
