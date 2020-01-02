//
//  signUpVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 12/31/19.
//  Copyright © 2019 Back4App. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController {

    @IBOutlet var avaImg: UIImageView!
    
    @IBOutlet var usernameTxt: UITextField!
    
    @IBOutlet var passwordTxt: UITextField!
    
    @IBOutlet var repeatTxt: UITextField!
    
    @IBOutlet var fullnameTxt: UITextField!
    
    @IBOutlet var bioTxt: UITextField!
    
    @IBOutlet var webTxt: UITextField!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    //reset scrollview height
    var scrollViewHeight: CGFloat = 0
    
    //keyboard frame size
    var keyboard = CGRect()
    
    @IBAction func signUpBtn_click(_ sender: Any) {
        //print("sign up pressed")
        //unwrap, take image file data from UIImageView
        let data = avaImg.image!.pngData()
        
        //convert taken image to file
        let file = PFFileObject(name: "ava.jpg", data: data!)
        
        //create a class/table/collection in back4apps
        let table = PFObject(className: "users")
        if let user = usernameTxt.text {
            table["username"] = user
        }
        
        if let pass = passwordTxt.text {
            table["password"] = pass
        }
        
        if let fullname = fullnameTxt.text{
            table["fullname"] = fullname
        }
        
        table["avatar"] = file
                
        table.saveInBackground(block: { (success:Bool, error:NSError?) in
            if success {
                print("User info saved in server")
            }else {
            
                print(error ?? "error")                       }
            } as? PFBooleanResultBlock)
         

        
    }
    
    @IBAction func cancelBtn_click(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Cancel pressed")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //scrollview frame size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        //check notifications if keyboard is shown or not
        //working
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: Selector(("showKeyboard(:)")), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap(_ :)))

        hideTap.numberOfTouchesRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
    }
    //hide keyboard if tapped
    @objc func hideKeyboardTap(_ recognizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    //show keyboard
    @objc func showKeyboard (_ notification:NSNotification) {
        //define keyboard size
        keyboard = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
                
        //move up UI
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
    }
    //hide keyboard
    @objc func hideKeyboard (_ notification:NSNotification) {
        
        //move down
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.view.frame.height
        }
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
