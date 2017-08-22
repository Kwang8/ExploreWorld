//
//  profileController.swift
//  ExploreWorld_1.0
//
//  Created by Kevin W on 8/15/17.
//  Copyright © 2017 Kevin W. All rights reserved.
//

import Foundation
import UIKit
class ProfileController : UIViewController{
    
    @IBOutlet var nameLabel: UILabel!

    @IBOutlet var totalPin: UILabel!
    
    @IBOutlet var Club: UILabel!
    
    var name = ""
    var cluba = ""
    
    var countPin = 0
    
    @IBAction func logoutPressed(_ sender: Any) {
        AuthService.presentLogOut(viewController: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        UserService.show(forUID: User.current.uid) { (user) in
            if let user = user {
                if(user.club==""){
                    
                    self.cluba = "none"
                }
                else{
                self.cluba = user.club
                }
                self.name = user.username
                self.nameLabel.text = self.name
                self.Club.text = self.cluba
        
            } else {
                // HANDLE ERROR: COULD NOT RETRIEVE USER
            }
        
        }
        
        PinService.showOne { (count) in
            if let count = count {
                self.totalPin.text = String(count)
            } else {
                // HANDLE
            }
        }
    
    
    }
}
