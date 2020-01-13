//
//  editVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/10/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit
import Parse

class editVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate ,UINavigationControllerDelegate {

    @IBOutlet var scrollView: UIScrollView!
    //@IBOutlet var avaImg: UIImageView!
    @IBOutlet var avaImg: UIImageView!
    
    @IBOutlet var fullnameTxt: UITextField!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var webTxt: UITextField!
    @IBOutlet var bioTxt: UITextView!
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var telTxt: UITextField!
    @IBOutlet var genderTxt: UITextField!
    
    //pickerview and pickerdata
    var genderPicker : UIPickerView!
    var genders = ["male", "female"]
    
    //value to hold keyboard frame size
    var keyboard = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //create picker
        genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        //genderPicker.showsSelectionIndicator = true  //deprecated
        //genderPicker.backgroundColor = UIColor.groupTableViewBackground  //deprecated
        genderTxt.inputView = genderPicker
        
        //check keyboard notifications, shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //tap keyboard to hide
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(sender:)))
        hideTap.numberOfTouchesRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //tap to choose image
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(loadimg(recognizer:)))
        imageTap.numberOfTouchesRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(imageTap)
        
        //call alignment
        alignment()
        
        //call information function
        information()
    }
    
    //retrieve user information
    func information() {
        let ava = PFUser.current()?.object(forKey: "ava") as! PFFileObject
        ava.getDataInBackground { (data, error) in
            if error == nil{
                self.avaImg.image = UIImage(data: data!)
            }else {
                print(error?.localizedDescription)
            }
        }
        fullnameTxt.text = PFUser.current()?.object(forKey: "fullname") as? String
        usernameTxt.text = PFUser.current()?.object(forKey: "username") as? String
        bioTxt.text = PFUser.current()?.object(forKey: "bio") as? String
        webTxt.text = PFUser.current()?.object(forKey: "web") as? String
      
        emailTxt.text = PFUser.current()?.object(forKey: "email") as? String
        telTxt.text = PFUser.current()?.object(forKey: "tel") as? String
        genderTxt.text = PFUser.current()?.object(forKey: "gender") as? String
        
    }
    
    //func to call UIImagePickerController
    @objc func loadimg(recognizer:UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        avaImg.image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard(sender:Any){
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        
        //keyboard = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]!.CGRect
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboard = keyboardFrame.cgRectValue
               //let keyboardHeight = keyboard.height
           }
        UIView.animate(withDuration: 0.4) {
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height/2
        }
                
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        UIView.animate(withDuration: 0.4) {
            self.scrollView.contentSize.height = 0
        }
    }
    
    //alignment
    func alignment()
    {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        avaImg.frame = CGRect(x: width - 68 - 10, y: 15, width: 68, height: 68)
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
         
        fullnameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y, width: width - avaImg.frame.size.width  - 50, height: 30)
        usernameTxt.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 40, width: width - avaImg.frame.size.width - 50, height: 30)
        webTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: width - 20, height: 30)
        
        bioTxt.frame = CGRect(x: 10, y: webTxt.frame.origin.y + 40, width: width - 20, height: 60)
        bioTxt.layer.borderWidth = 1
        bioTxt.layer.borderColor = UIColor(red: 230/255.5, green: 230/255.5, blue: 230/255.5, alpha: 1).cgColor  //UIColor.lightGray.cgColor
        bioTxt.layer.cornerRadius = bioTxt.frame.size.width / 50
        bioTxt.clipsToBounds = true

        titleLbl.frame = CGRect(x: 10, y: bioTxt.frame.origin.y + 90, width: width - 20, height: 30)
        emailTxt.frame = CGRect(x: 10, y: titleLbl.frame.origin.y + 40, width: width - 20, height: 30)
        telTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: width - 20, height: 30)
        genderTxt.frame = CGRect(x: 10, y: telTxt.frame.origin.y + 40, width: width - 20, height: 30)
        
    }
    
    
    @IBAction func cancel_clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //regular expression(regex) for email textfield
    func validateEmail(email : String) -> Bool{
        
        return email.isValidEmail
        
        /*
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
         //"[A-Z0-9a-z._%+-]{4}+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,6}"
        let range = email.range(of: regex)
        let result = range != nil ? true : false
        return result
         */
    }
    
    //regex for web text
    func validateWeb(web : String) -> Bool {
        
        return web.isValidUrl
        /*
        let regex = "www.[A-Za-z0-9._%+-]+.[A-Za-z]{2}"
        let range = web.range(of: regex)
        let result = range != nil ? true : false
        return result
         */
    }
    
    //alert message function
    func alert(error : String, message : String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    //clicked save button
    @IBAction func save_clicked(_ sender: Any) {
        
        //validate email and web
        if !validateEmail(email: emailTxt.text!) {
            alert(error: "Incorrect email", message: "Please provide correct email address")
            return
        }
        if !validateWeb(web: webTxt.text!) {
            alert(error: "Incorrect web link", message: "Please provide correct web address")
            return
        }
        
        //save filled in information
        let user = PFUser.current()!
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user["fullname"] = fullnameTxt.text?.lowercased()
        user["web"] = webTxt.text?.lowercased()
        user["bio"] = bioTxt.text
        
        //if tel is empty, send empty data, elsed entered data
        if telTxt.text!.isEmpty{
            user["tel"] = ""
        }else {
            user["tel"] = telTxt.text
        }
        if genderTxt.text!.isEmpty {
            user["gender"] = ""
        }else{
            user["gender"] = genderTxt.text
        }
        
        //update ava picture
        let avaData = avaImg.image?.jpegData(compressionQuality: 0.5)
        let avaFile = PFFileObject(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        //send filled information to server
        user.saveInBackground { (success:Bool, error:Error?) in
            if success {
                
                //hide keyboard
                self.view.endEditing(true)
                
                //dismiss editVC
                self.dismiss(animated: true, completion: nil)
                
                //send notification to homeVC to reload                
                NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
                
            }else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    //PICKER VIEW METHODS
    //picker component number
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //picker text number
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    //picker text config
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    //user did select from picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTxt.text = genders[row]
        self.view.endEditing(true)
    }
    
    

}



extension String {
   var isValidEmail: Bool {
      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
      return testEmail.evaluate(with: self)
   }
   var isValidPhone: Bool {
      let regularExpressionForPhone = "^\\d{3}-\\d{3}-\\d{4}$"
      let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
      return testPhone.evaluate(with: self)
   }
    
    var isValidUrl: Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
}
