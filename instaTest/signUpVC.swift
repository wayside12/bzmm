//
//  signUpVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 12/31/19.
//  Copyright © 2019 Back4App. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var avaImg: UIImageView!
    
    @IBOutlet var usernameTxt: UITextField!
    
    @IBOutlet var passwordTxt: UITextField!
    
    @IBOutlet var repeatTxt: UITextField!
    
    @IBOutlet var emailTxt: UITextField!
    
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
     
        self.view.endEditing(true)
        
        //if fields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || emailTxt.text!.isEmpty || repeatTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || bioTxt.text!.isEmpty || webTxt.text!.isEmpty {
            let alert = UIAlertController(title: "Please", message: "fill all fields", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        if passwordTxt.text != repeatTxt.text {
            let alert = UIAlertController(title: "Password", message: "do not match", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        //send data to server to related columns
        let user = PFUser()
        user.username = usernameTxt.text?.lowercased()
        user.password = passwordTxt.text
        user.email = emailTxt.text?.lowercased()
        user["fullname"] = fullnameTxt.text?.lowercased()
        user["bio"] = bioTxt.text
        user["web"] = webTxt.text?.lowercased()
        
        //in edit profile it's going to be assigned
        user["tel"] = ""
        user["gender"] = ""
        
        //convert image for sending to server
        let avaData = avaImg.image?.jpegData(compressionQuality: 0.5)
        let avaFile = PFFileObject(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
                
        //save data in server
        user.signUpInBackground { (success, error) in
            if success {
                print("registered")
                
                //remember username
                UserDefaults.standard.set(user.username, forKey: "username")
                //UserDefaults.synchronize()
                
                //call login function from appDelegate class
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
                
            }else {
                print(error?.localizedDescription)
            }
        }
        
     /*
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
         
*/
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap(_ :)))
        hideTap.numberOfTouchesRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width/2
        avaImg.clipsToBounds = true
        
        
        //declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(loadImg(_ :)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        avaImg.frame = CGRect(x: self.view.frame.width/2 - 40, y: 40, width: 80, height: 80)
        usernameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y + 90, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        repeatTxt.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        
        emailTxt.frame = CGRect(x: 10, y: repeatTxt.frame.origin.y + 60, width: self.view.frame.size.width - 20, height: 30)
        fullnameTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        bioTxt.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        webTxt.frame = CGRect(x: 10, y: bioTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        
        signUpBtn.frame = CGRect(x: 20, y: webTxt.frame.origin.y + 50, width: self.view.frame.size.width/4, height: 30)
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width/4 - 20 , y: signUpBtn.frame.origin.y, width: self.view.frame.size.width/4, height: 30)
        
        
        
    }
    //call picker to select image
    @objc func loadImg(_ recognizer:UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    //connect selected image to imageview
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        avaImg.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
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
