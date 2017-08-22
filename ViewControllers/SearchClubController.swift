//
//  SearchClubController.swift
//  ExploreWorld_1.0
//
//  Created by Kevin W on 8/10/17.
//  Copyright © 2017 Kevin W. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase
import FirebaseAuth
import UIKit
class ClubController:UIViewController{
    
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var textView: UITextView!
    var namea:String = ""
    var name:String = ""
    var clubs:[Club] = []
    var pinCount:Int = 0
    var textViewText:String? = ""
    var testName = 0
    var username = ""
    var password = "none"
    var privateTest = 0
    var user = ""
    var totalPinCount = 0
    @IBAction func nameFieldPressed(_ sender: Any) {
        namea = nameField.text!
    }
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   
    @IBOutlet var passwordField: UITextField!
    override func viewDidAppear(_ animated: Bool) {
        UserService.show(forUID: User.current.uid) { (user) in
            if let user = user {
                
                self.user = user.club
                self.username = user.username
                
            } else {
                // HANDLE ERROR: COULD NOT RETRIEVE USER
            }
        }
        passwordField.isUserInteractionEnabled = false
        passwordField.text = ""
        refresh()
    }
    @IBAction func CreatePressed(_ sender: Any) {
        textViewText = textView.text
        if(textViewText==nil){
            textViewText=""
        }
        namea = nameField.text!
        if(namea==""){
            error()
        }
        else if(user != ""){
            errorClub()
        }
        else{
            
        let nameCount = namea.characters.count
        
        let countA = namea.characters.filter{$0 == " "}.count
        if(countA==nameCount){
            error()
        }
            
            if(clubs.count==0){
                ClubService.createClub(name: namea, users: 1, pins: 0, descriptionClub: textViewText!, username:User.current.uid,pass:passwordField.text!, completion:
                    { (club) in
                        return
                })
                ClubService.addMemberToClub(role: "Owner", pins: totalPinCount, username:User.current.uid, name: nameField.text!, success: { (user) in
                    
                })
                
                dismiss(animated: true, completion: nil)

            }
            else{
                ClubService.addMemberToClub(role: "Owner", pins: totalPinCount, username: User.current.uid, name: nameField.text!, success: { (user) in
                    
                })
            for x in 0...clubs.count-1{
                if(clubs[x].name==namea){
                    testName = 1
                }
                else{}
            }
            if(testName==0){
                ClubService.createClub(name: namea, users: 1, pins: 0, descriptionClub: textViewText!,username: User.current.uid, pass:passwordField.text!, completion:
            { (club) in
                return
            })
                ClubService.addMemberToClub(role: "Owner", pins: totalPinCount, username: User.current.uid, name: nameField.text!, success: { (user) in
                    
                })
            
            dismiss(animated: true, completion: nil)
            }
            
            else{
                errorName()
                }
            }
        }
    }
    
    @IBAction func `switch`(_ sender: Any) {
        if((sender as AnyObject).isOn==true){
            
            passwordField.text = ""
            passwordField.isUserInteractionEnabled = false
        }
        else{
            passwordField.isUserInteractionEnabled = true
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        PinService.showOne { (count) in
            if let count = count {
                self.totalPinCount = count
            } else {
                // HANDLE
            }
        }
        hideKeyboardWhenTappedAround()
        UserService.show(forUID: User.current.uid) { (user) in
            if let user = user {
                self.name = user.club
            } else {
                // HANDLE ERROR: COULD NOT RETRIEVE USER
            }
        }
        textView!.layer.borderWidth = 5
        textView!.layer.borderColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.0).cgColor
    }
    func error(){
        let invalidMoneyAlert = UIAlertController(title: "didnt fill out requirements", message: "please fill out requirements", preferredStyle: UIAlertControllerStyle.alert)
        invalidMoneyAlert.addAction(UIAlertAction(title:"ok", style: UIAlertActionStyle.default,handler:nil))
        self.present(invalidMoneyAlert, animated:true,completion:nil)
    }
    func errorName(){
        let invalidMoneyAlerta = UIAlertController(title: "Club Name Taken", message: "please choose a new name", preferredStyle: UIAlertControllerStyle.alert)
        invalidMoneyAlerta.addAction(UIAlertAction(title:"ok", style: UIAlertActionStyle.default,handler:nil))
        self.present(invalidMoneyAlerta, animated:true,completion:nil)
    }
    func refresh(){
        ClubService.showClubs() { (clubs) in
            guard let clubs = clubs else{
                return
                
            }
            
            self.clubs=clubs
        }
}
    func errorClub(){
        let invalidMoneyAlerta = UIAlertController(title: "too many clubs", message: "please leave your current club", preferredStyle: UIAlertControllerStyle.alert)
        invalidMoneyAlerta.addAction(UIAlertAction(title:"ok", style: UIAlertActionStyle.default,handler:nil))
        self.present(invalidMoneyAlerta, animated:true,completion:nil)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboarda))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboarda() {
        view.endEditing(true)
    }
    
}

 
 
 
 
 
 
 
 
 
 
 

