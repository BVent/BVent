//
//  editProfileViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 27/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class editProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameField4: UITextField!
    @IBOutlet weak var emailField4: UITextField!
    @IBOutlet weak var phoneNumberField4: UITextField!
    @IBOutlet weak var passwordField4: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullNameField4.delegate = self
        emailField4.delegate = self
        phoneNumberField4.delegate = self
        passwordField4.delegate = self
        
        fullNameField4.keyboardType = UIKeyboardType.alphabet
        emailField4.keyboardType = UIKeyboardType.emailAddress
        phoneNumberField4.keyboardType = UIKeyboardType.namePhonePad
        passwordField4.keyboardType = UIKeyboardType.alphabet
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer)  {
        view.endEditing(true)
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil){
            Notification in
            self.keyboardWillShow(notification: Notification)
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil){
            notification in
            self.keyboardWillHIde(notification: notification)
        }
    }
    
    func removeObserver(){
        NotificationCenter.default.removeObserver(self)
    }
    func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHIde(notification: Notification){
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameField4{
            fullNameField4.becomeFirstResponder()
        }
        if textField == emailField4{
            emailField4.becomeFirstResponder()
        }
        if textField == phoneNumberField4{
            phoneNumberField4.becomeFirstResponder()
        }
        if textField == passwordField4{
            passwordField4.resignFirstResponder()
        }
        
        return true
    }
    
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        User.logOutUser { (status) in
            if status == true {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateProfile(_ sender: Any) {
        if ((emailField4.text != "" || fullNameField4.text != "" || phoneNumberField4.text != "") && (emailField4.text != nil || fullNameField4.text != nil || phoneNumberField4.text != nil)){
            let userID = Auth.auth().currentUser?.uid
            
            let userRef = Database.database().reference().child("users").child("regular").child(userID!).child("profile")
            if let new_Email = emailField4.text as? String{
                
                Auth.auth().currentUser!.updateEmail(to: emailField4.text!) { error in
                    
                    if error == nil{
                        userRef.updateChildValues(["email" : new_Email ], withCompletionBlock: {(errEM, referenceEM)   in
                            
                            if errEM == nil{
                                print(referenceEM)
                            }else{
                                print(errEM?.localizedDescription)
                            }
                        })
                    }
                    else {
                        print("Error Updating Profile!")
                    }
                }
            }
            
            if let new_Name = fullNameField4.text as? String{
                
                userRef.updateChildValues(["fullname" : new_Name ], withCompletionBlock: {(errNM, referenceNM)   in
                    
                    if errNM == nil{
                        print(referenceNM)
                    }else{
                        print(errNM?.localizedDescription)
                    }
                })
            }
            
            if let new_PhoneNumber = phoneNumberField4.text as? String {
                userRef.updateChildValues(["phoneNumber" : new_PhoneNumber ], withCompletionBlock: {(errNM, referenceNM)   in
                    
                    if errNM == nil{
                        print(referenceNM)
                    }else{
                        print(errNM?.localizedDescription)
                    }
                })
            }
            _ = self.navigationController?.popViewController(animated: true)
            
        }else{
            
            print("Please fill in one or more of the missing text fields that you would like to update.")
            
        }
    }
    
}
