//
//  Club.swift
//  ExploreWorld_1.0
//
//  Created by Kevin W on 8/10/17.
//  Copyright © 2017 Kevin W. All rights reserved.
//import Foundation
import UIKit
import Foundation
import FirebaseDatabase.FIRDataSnapshot
//this is my class to create a format to create pins used in the main view controller//
class Club: NSObject{
    let name: String?
    let users: Int?
    let pins: Int?
    let pass: String?
    let descriptionClub: String?
    let username: String?
    var dictValuePin: [String : Any] {
        return ["name": name!,
                "users": users!,
                "pins": pins!,
                "username":username!,
                "descriptionClub": descriptionClub!,
        "pass": pass!]
    }
    init(name:String, users:Int, pins:Int , descriptionClub:String, username:String, pass:String){
        self.name=name
        self.users=users
        self.pins=pins
        self.pass = pass
        self.username=username
        self.descriptionClub=descriptionClub
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let name = dict["name"]as? String,
            let users = dict["users"]as? Int,
            let pins = dict["pins"]as? Int,
            let pass = dict["pass"]as? String,
            let username = dict["username"]as? String,
            let descriptionClub = dict["descriptionClub"]as? String
            else { return nil }
        self.name = name
        self.users = users
        self.pass = pass
        self.username = username
        self.pins=pins
        self.descriptionClub=descriptionClub
    }
}
