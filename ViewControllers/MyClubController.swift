//
//  myClubController.swift
//  ExploreWorld_1.0
//
//  Created by Kevin W on 8/15/17.
//  Copyright © 2017 Kevin W. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import UIKit
class MyClubController : UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet var totalMembers: UILabel!
    @IBOutlet var pinLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var thirdField: UILabel!
    @IBOutlet var twoField: UILabel!
    @IBOutlet var oneField: UILabel!
    var namea = ""
    var cluba = ""
    var ownerName = ""
    var pinClub:[Pin] = []
    var refresher: UIRefreshControl!
    var userArr:[Member] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    @IBAction func leave(_ sender: Any) {
        errorSure()
    }
    func refresh(){
        UserService.show(forUID: User.current.uid) { (user) in
            if let user = user {
                self.namea = user.username
                self.cluba = user.club
                if(self.cluba == ""){
                    self.errorClub()
                }
                else{
                self.thirdField.text = "\(self.cluba)"
                PinService.showClub(name: self.cluba) { (pin) in
                    if let pin = pin{
                        self.pinClub = pin
                        self.oneField.text = "\(self.pinClub.count)"
                    }
                    else{
                        print("not working")
                        return
                    }
                    }
                
                
                ClubService.showMembers(name: self.cluba) { (user) in
                    if let user = user{
                        self.userArr = user
                        if(self.userArr.count==1){
                            
                            self.ownerName = self.userArr[0].username!
                        }
                        else{
                        for c in 0...self.userArr.count{
                            if(self.userArr[c].role=="owner"){
                                self.ownerName = self.userArr[c].username!
                                
                                break
                            }
                        }
                        }
                        self.twoField.text = "\(self.userArr.count)"
                        self.tableView.reloadData()
                        self.refresher.endRefreshing()
                        
                    }
                    else{
                    }
                }
                }
            }else {
                // HANDLE ERROR: COULD NOT RETRIEVE USER
            }
            
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        refresher = UIRefreshControl()
        self.tableView.addSubview(refresher)
        refresh()
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        refresh()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("work")
        let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as! TableViewCellMember
        UserService.show(forUID: self.userArr[indexPath.row].username!) { (user) in
            if let user = user {
                cell.label.text = user.username
                
                cell.role.text = "\(self.userArr[indexPath.row].role!)"
                cell.pins.text = "\(self.userArr[indexPath.row].pins!)"
            } else {
                // HANDLE ERROR: COULD NOT RETRIEVE USER
            }
        }

        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        //if(self.ownerName == self.namea){
            let kickModal = UITableViewRowAction(style: .normal, title: "Kick") { (action, index) in
            let kickedUser = self.userArr[editActionsForRowAt.row]
            let ownerTest = self.userArr[editActionsForRowAt.row].role
            if(ownerTest == "owner)"){
                self.errorOwnerKicked()
            }
            else{
            let userInClubReference = Database.database().reference().child("Clubs").child(self.cluba).child("members").child(User.current.uid)
            let dank = Database.database().reference().child("users").child(User.current.uid).child("club")
            userInClubReference.removeValue()
            dank.setValue("")
                }
        }
    
        return [kickModal]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func errorClub(){
        let invalidMoneyAlerta = UIAlertController(title: "no club", message: "Try joining a club before using this function!:D", preferredStyle: UIAlertControllerStyle.alert)
        invalidMoneyAlerta.addAction(UIAlertAction(title:"Join a club", style: UIAlertActionStyle.default,handler:nil))
        self.present(invalidMoneyAlerta, animated:true,completion:nil)
        self.performSegue(withIdentifier: "goToSearch", sender: nil)
        self.tabBarController?.selectedIndex = 2
    }
    func errorOwnerKicked(){
        let invalidMoneyAlerta = UIAlertController(title: "Cant kick youself!", message: "If you wish to leave just press leave on the My Club page :D", preferredStyle: UIAlertControllerStyle.alert)
        invalidMoneyAlerta.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.default,handler:nil))
        self.present(invalidMoneyAlerta, animated:true,completion:nil)
        
        self.tabBarController?.selectedIndex = 2
    }
    func errorSure(){
        let invalidMoneyAlerta = UIAlertController(title: "are you sure you want to leave?", message: "Once you leave you will leave forever unless you join back", preferredStyle: UIAlertControllerStyle.alert)
        invalidMoneyAlerta.addAction(UIAlertAction(title: "yes", style: UIAlertActionStyle.default, handler: {action -> Void in
            if(self.ownerName == User.current.uid){
                let dank = Database.database().reference().child("users").child(User.current.uid).child("club")
                
                let userInClubReference = Database.database().reference().child("Clubs").child(self.cluba)
                userInClubReference.removeValue()
                dank.setValue("")
            }
            else{
                let dank = Database.database().reference().child("users").child(User.current.uid).child("club")
                
                let userInClubReference = Database.database().reference().child("Clubs").child(self.cluba).child("members").child(User.current.uid)
                userInClubReference.removeValue()
                dank.setValue("")
                
                UserDefaults.standard.set("", forKey: "club")
            }
        }))
        invalidMoneyAlerta.addAction(UIAlertAction(title: "no", style: UIAlertActionStyle.default, handler: {action -> Void in

        }))
        self.present(invalidMoneyAlerta, animated:true,completion:nil)
        
        self.tabBarController?.selectedIndex = 2
    }

}



class TableViewCellMember:UITableViewCell{
    @IBOutlet var pins: UILabel!
    @IBOutlet var label: UILabel!
    @IBOutlet var role: UILabel!
    
}
