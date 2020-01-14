//
//  uploadVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/13/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit
import Parse

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var picImg: UIImageView!
    @IBOutlet var titleTxt: UITextView!
    @IBOutlet var publishBtn: UIButton!
    @IBOutlet var removeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //diable publish button until image loaded
        publishBtn.isEnabled = false
        publishBtn.backgroundColor = .lightGray
        
        // hide remove button
        removeBtn.isEnabled = false
        
        //standard bg pic
        picImg.image = UIImage(named: "postbg.jpeg")
        //titleTxt.text = ""
        
        //hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap(sender:)))
        hideTap.numberOfTouchesRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //select image tap
        let picTap = UITapGestureRecognizer(target: self, action: #selector(selectImg(sender:)))
        picTap.numberOfTouchesRequired = 1
        self.picImg.isUserInteractionEnabled = true
        self.picImg.addGestureRecognizer(picTap)
        
        
        alignment()
     
    }
    
    //func to call pickerViewController
    @objc func selectImg(sender:Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true //TODO: cannot edit image
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picImg.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        //enable publish button
        publishBtn.isEnabled = true
        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        //unhide remove button
        removeBtn.isEnabled = true
        
        //implement the second tap to zoom in/out
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(zoomimg(sender:)))
        zoomTap.numberOfTouchesRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(zoomTap)
        
    }
    
    @objc func zoomimg(sender:Any){
        
        //define frame of unzoomed image
        let unzoomed = CGRect(x: 10, y: self.navigationController!.navigationBar.frame.size.height + 35, width: self.view.frame.size.width / 4.5, height: self.view.frame.size.width / 4.5)
        
        //define frame of zoomed image
        let zoomed = CGRect(x: 0, y: self.view.center.y - self.view.center.x, width: self.view.frame.size.width, height: self.view.frame.size.width)
        if picImg.frame == unzoomed {
            UIView.animate(withDuration: 0.3) {
                self.picImg.frame = zoomed
                
                //hide objects from background
                self.view.backgroundColor = .black
                self.titleTxt.alpha = 0
                self.publishBtn.alpha = 0
                
                //hide remove button
                self.removeBtn.isEnabled = false
            }
        }else{
            
            UIView.animate(withDuration: 0.3) {
                self.picImg.frame = unzoomed
                
                //unhide objects from background
                self.view.backgroundColor = .white
                self.titleTxt.alpha = 1
                self.publishBtn.alpha = 1
                
                //unhide remove button
                self.removeBtn.isEnabled = true
            }
        }
    }
    
    
    @objc func hideKeyboardTap(sender:Any) {
        self.view.endEditing(true)
        
        
    }
    
    func alignment() {
        
        let width = self.view.frame.size.width
        picImg.frame = CGRect(x: 10, y: self.navigationController!.navigationBar.frame.size.height + 35, width: width / 4.5, height: width / 4.5)
        titleTxt.frame = CGRect(x: picImg.frame.size.width + 25, y: picImg.frame.origin.y, width: width - picImg.frame.size.width - 40, height: picImg.frame.size.height)
        publishBtn.frame = CGRect(x: 0, y: self.tabBarController!.tabBar.frame.origin.y - width / 8, width: width, height: width/8)
        removeBtn.frame = CGRect(x: picImg.frame.origin.x, y: picImg.frame.origin.y + picImg.frame.size.height + 15, width: picImg.frame.size.width, height: 30)
    }
    
    //clicked publish button
    @IBAction func publishBtn_clicked(_ sender: Any) {
        //dismiss keyboard
        self.view.endEditing(true)
        
        //collect data for class 'post'
        let object = PFObject(className: "post")
        object["username"] = PFUser.current()?.username
        object["ava"] = PFUser.current()?.value(forKey: "ava") as! PFFileObject
        object["uuid"] = "\(PFUser.current()?.username)\(NSUUID().uuidString)"
        
        if titleTxt.text == "" {
            object["title"] = ""
        }else{
            object["title"] = titleTxt.text.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        }
        //convert image to file and compress
        let imageData = picImg.image?.jpegData(compressionQuality: 0.5)
        let imageFile = PFFileObject(name: "post.jpg", data: imageData!)
        object["pic"] = imageFile
        
        //save to Parse server
        object.saveInBackground { (success, error) in
            if success{
                
                print("saved on the server!")
                //send notification with name "uploaded"
                NotificationCenter.default.post(name: NSNotification.Name("uploaded"), object: nil)
              
                //switch to another view controller with 0 index of tabbar
                self.tabBarController?.selectedIndex = 0
                
                //reset everything
                self.viewDidLoad()
                self.titleTxt.text = ""
                
            }else{
                print(error?.localizedDescription)
            }
        }
         
    }
    
    @IBAction func removeBtn_clicked(_ sender: Any) {
        self.viewDidLoad()
    }
    

}
