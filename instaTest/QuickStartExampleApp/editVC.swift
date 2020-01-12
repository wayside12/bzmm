//
//  editVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/10/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit
import Parse

class editVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var scrollView: UIScrollView!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //create picker
        genderPicker = UIPickerView()
        
        genderPicker.dataSource = self
        genderPicker.delegate = self
        //genderPicker.showsSelectionIndicator = true
        //genderPicker.backgroundColor = UIColor.groupTableViewBackground
        genderTxt.inputView = genderPicker
        
        
        //call alignment
        alignment()
    }
    
    
    //alignment
    func alignment()
    {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        avaImg.frame = CGRect(x: width - 68 - 10, y: 15, width: 68, height: 68)
        avaImg.layer.cornerRadius = width / 2
        avaImg.clipsToBounds = true
         
        fullnameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y, width: width - avaImg.frame.size.width  - 30, height: 30)
        usernameTxt.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 40, width: width - avaImg.frame.size.width - 30, height: 30)
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
