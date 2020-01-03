//
//  signInVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 12/31/19.
//  Copyright © 2019 Back4App. All rights reserved.
//

import UIKit
import Parse

class signInVC: UIViewController {

    @IBOutlet var usernameTxt: UITextField!
    
    @IBOutlet var passwordTxt: UITextField!
    
    @IBOutlet var signInBtn: UIButton!
    
    @IBOutlet var signUpBtn: UIButton!
    
    @IBOutlet var forgotBtn: UIButton!
    
    @IBAction func signInBtn_click(_ sender: Any) {
        
        print("sign in clicked!")
        self.view.endEditing(true)
        
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            let alert = UIAlertController(title: "Please", message: "fill in all fields", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        //login function
        
        //PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user:PFUser?, error:NSError?) -> Void in
        //}
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user: PFUser?, error:Error?) in
            if error == nil {
                   //remember user
                   
                   UserDefaults.standard.set(user!.username, forKey: "username")
                   //UserDefaults.synchronize(UserDefaults)
                   
                   //call login function from AppDelegate class
                   let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                   appDelegate.login()
                   
                   
               }else {
                   print(error!.localizedDescription)
               }
        }
        
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
