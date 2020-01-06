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
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
           super.viewDidLoad()

        //pacifico font
        label.font = UIFont(name: "Pacifico", size: 25)
        
        //alignment
        label.frame = CGRect(x: 10, y: 80, width: self.view.frame.size.width - 20, height: 50)
        usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y + 70, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        forgotBtn.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        signInBtn.frame = CGRect(x: 20, y: forgotBtn.frame.origin.y + 40, width: self.view.frame.size.width/4, height: 30)
        signUpBtn.frame = CGRect(x: self.view.frame.width - self.view.frame.width/4 - 20 , y: forgotBtn.frame.origin.y + 40, width: self.view.frame.width/4, height: 30)
    
        //hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap(_:)))
        hideTap.numberOfTouchesRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
    
        //background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
                
       }
    
    @objc func hideKeyboardTap(_ recognizer:UITapGestureRecognizer){
        
        self.view.endEditing(true)
    }
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
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user: PFUser?, error:Error?) in
            if error == nil {
                   //remember user
                   
                   UserDefaults.standard.set(user!.username, forKey: "username")
                   //UserDefaults.synchronize(UserDefaults)
                   
                   //call login function from AppDelegate class
                   let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                   appDelegate.login()
                   
                   
               }else {
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    
   
    

}
