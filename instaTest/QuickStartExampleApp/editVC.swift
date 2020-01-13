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
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height/4
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
    @IBAction func save_clicked(_ sender: Any) {
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
