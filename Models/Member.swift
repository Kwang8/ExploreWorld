//
//  Member.swift
//  ExploreWorld_1.0
//
//  Created by Kevin W on 8/15/17.
//  Copyright © 2017 Kevin W. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import FirebaseDatabase.FIRDataSnapshot
//this is my class to create a format to create pins used in the main view controller//
class Member: NSObject{
    let username: String?
    let role: String?
    let pins: Int?
    var dictValuePin: [String : Any] {
        return ["username": username!,
                "role": role!,
                "pins": pins!,]
    }
    init(username:String, role:String, pins:Int){
        self.username=username
        self.role=role
        self.pins=pins
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"]as? String,
            let role = dict["role"]as? String,
            let pins = dict["pins"]as? Int
            else{return nil}
        self.username = username
        self.role = role
        self.pins = pins
    }
}
