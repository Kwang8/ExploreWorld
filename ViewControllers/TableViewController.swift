//
//  tableViewController.swift
//  ExploreWorld_1.0
//
//  Created by Kevin W on 8/9/17.
//  Copyright © 2017 Kevin W. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import UIKit
class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var clubs:[Club] = []
    var a=["hi"]
    var clubID:[String] = []
    var refresher: UIRefreshControl!
    func refresh(){
        ClubService.showClubs() { (clubs) in
            guard let clubs = clubs else{
               
                return
            }
            self.clubs=clubs
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }

        
    }
    @IBAction func CreatePressed(_ sender: Any) {
        performSegue(withIdentifier: "createPressed", sender: nil)
    }
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
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
        return clubs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("work")
        let cell = tableView.dequeueReusableCell(withIdentifier: "listNotesTableViewCell", for: indexPath) as! TableViewCell
        cell.label.text = "\(clubs[indexPath.row].name!)"
        cell.usersLabel.text = "\(clubs[indexPath.row].users!)"
        cell.pinsLabel.text = "\(clubs[indexPath.row].pins!)"
        if(clubs[indexPath.row].pass==""){
            
        }
        else{
        cell.passwordImage.image = UIImage(named:"pass")
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    UserDefaults.standard.set(indexPath.row, forKey: "name")
    self.performSegue(withIdentifier: "cellPressed", sender: self)
    }
}
class TableViewCell:UITableViewCell{
    @IBOutlet var usersLabel: UILabel!
    @IBOutlet var pinsLabel: UILabel!
    @IBOutlet var label: UILabel!
    @IBOutlet var passwordImage: UIImageView!
    }



