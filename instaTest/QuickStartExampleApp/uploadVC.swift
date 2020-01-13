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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //diable publish button until image loaded
        publishBtn.isEnabled = false
        publishBtn.backgroundColor = .lightGray
        
        //hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap(sender:)))
        hideTap.numberOfTouchesRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //select image tap
        let picTap = UITapGestureRecognizer(target: self, action: #selector(selectImg(sender:)))
        picTap.numberOfTouchesRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(picTap)
        
        
        
        alignment()
     
    }
    
    //func to call pickerViewController
    @objc func selectImg(sender:Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picImg.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        //enable publish button
        publishBtn.isEnabled = true
        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
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
            }
        }else{
            
            UIView.animate(withDuration: 0.3) {
                self.picImg.frame = unzoomed
                
                //unhide objects from background
                self.view.backgroundColor = .white
                self.titleTxt.alpha = 1
                self.publishBtn.alpha = 1
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
        
    }
    
    


}
