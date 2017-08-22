//
//  Pin.swift
//  ExploreWorld_1.0
//
//  Created by Kevin W on 7/25/17.
//  Copyright © 2017 Kevin W. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import FirebaseDatabase.FIRDataSnapshot
    //this is my class to create a format to create pins used in the main view controller//
class Pin: NSObject{
    let title: String?
    let subtitle:String?
    let latitude:Double?
    let longitude:Double?
    var dictValuePin: [String : Any] {
        return ["longitude": longitude!,
                "latitude": latitude!,
                "title": title!,
                "subtitle": subtitle!]
    }
    init(title:String, subtitle:String, longitude:Double , latitude:Double){
        self.title=title
        self.subtitle=subtitle
        self.longitude=longitude
        self.latitude=latitude
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let longitude = dict["longitude"]as? Double,
            let latitude = dict["latitude"]as? Double,
            let title = dict["title"]as? String,
            let subtitle = dict["subtitle"]as? String
            else { return nil }
        self.title = title
        self.subtitle = subtitle
        self.longitude=longitude
        self.latitude=latitude
    }
}
