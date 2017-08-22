//
//  IndividualClub.swift
//  ExploreWorld_1.0
//
//  Created by Kevin W on 8/11/17.
//  Copyright © 2017 Kevin W. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import UIKit
class individualClub:UIViewController{
    var namea:Int = 0
    var clubs:[Club] = []
    var user:String = ""
    var current = ""
    var password = ""
    var totalPinCount=0
    var username = ""
    var name = ""
    @IBOutlet var joinButton: UIButton!
    @IBOutlet var NameField: UILabel!
    @IBOutlet var descriptionField: UILabel!
    @IBOutlet var membersTableView: UITableView!
    
    @IBOutlet var membersLabel: UILabel!
    
    @IBOutlet var passField: UITextField!
    @IBOutlet var pinsLabel: UILabel!
    
    @IBAction func joinPressed(_ sender: Any) {
      
        if(user==""){
            
            if(password==""){
                ClubService.addMemberToClub(role: "member", pins: totalPinCount, username: username, name: NameField.text!, success: { (user) in
                    
                    UserDefaults.standard.set(self.NameField.text, forKey: "club")
                    
                })
            }
        
            
                
                
            else{
                
                
                if(passField.text == password){
                    ClubService.addMemberToClub(role: "member", pins: totalPinCount, username: username, name: NameField.text!, success: { (user) in
                        
                    })
                }
                    
                    
                else{
                    error()
                }
        }
        }
    
            else{
            errorName()
        
        }
    }
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        PinService.showOne { (count) in
            if let count = count {
                self.totalPinCount = (count)
            } else {
                // HANDLE
            }
        }
    namea=(UserDefaults.standard.object(forKey: "name") as! Int? ?? 0)
            UserService.show(forUID: User.current.uid) { (user) in
                if let user = user {
                    
                    self.user = user.club
                    self.username = user.username
                    
                    
                    
                } else {
                    // HANDLE ERROR: COULD NOT RETRIEVE USER
                }
        }
    
        ClubService.showClubs() { (clubs) in
            guard let clubs = clubs else{
                return
            }
            self.clubs = clubs
            self.NameField.text = clubs[self.namea].name
            self.descriptionField.text = clubs[self.namea].descriptionClub
            self.password = clubs[self.namea].pass!
            if(self.password)==""{
                self.passField.isHidden  = true
            }
            else{
                self.passField.isHidden = false
                self.passField.placeholder = "password"
                self.password = clubs[self.namea].pass!
            }
    }
    
        
    
    
    }
    func error(){
        let invalidMoneyAlert = UIAlertController(title: "wrong password", message: "please retype password", preferredStyle: UIAlertControllerStyle.alert)
        invalidMoneyAlert.addAction(UIAlertAction(title:"ok", style: UIAlertActionStyle.default,handler:nil))
        self.present(invalidMoneyAlert, animated:true,completion:nil)
    }
    func errorName(){
        let invalidMoneyAlerta = UIAlertController(title: "too many clubs", message: "please leave your current club", preferredStyle: UIAlertControllerStyle.alert)
        invalidMoneyAlerta.addAction(UIAlertAction(title:"ok", style: UIAlertActionStyle.default,handler:nil))
        self.present(invalidMoneyAlerta, animated:true,completion:nil)
    }
}
