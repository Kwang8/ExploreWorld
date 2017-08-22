//
//  ViewController.swift
//  ExploreWorld_1.0
//
//  Created by Kevin W on 7/24/17.
//  Copyright © 2017 Kevin W. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase
// this is my main view controler class here my map is set and pins are added//
class CustomPointAnnotation: MKPointAnnotation {
    var image: String!
}

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var pins : [Pin] = []
    var counterOther = 0
    var testPinsCount = 0
    var username = ""
    var annotation = CustomPointAnnotation()
    var longitude: [Double] = []
    var latitude: [Double] = []
    var titlePin: [String] = []
    var subtitle: [String] = []
    var slider = 50
    var pinsLength=0
    let locationManager = CLLocationManager()
    var pinType:String? = ""
    var pinQuality:Double? = 9.0
    let current = UserDefaults.standard
    var timeTest=0
    var firstTest=0
    var name = ""
    var clubTest = 0
    var city = ""
    var long = 0.0
    var lat = 0.0
    var clubPinsCount = 0
    @IBOutlet var switcha: UISwitch!
    @IBAction func switchChanged(_ sender: Any) {
        if((sender as AnyObject).isOn==true){
            clubTest = 1
        }
        else{
            clubTest = 0
        }
    }
    @IBOutlet weak var rangeSlider: UISlider!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func rangeSliderChanged(_ sender: UISlider) {
        slider=Int(sender.value)
        refresh()
    }
    @IBOutlet weak var refreshButton: UIButton!
    @IBAction func refreshClicked(_ sender: Any) {
        
        self.refreshButton.isEnabled=false
        let imageName = "earth"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.image = image
        imageView.frame = CGRect(x: 168, y: 268, width: 50, height: 50)
        self.view.addSubview(imageView)
        
        imageView.rotate360Degrees()
        let delayInSeconds = 1.0
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.zipcode(completion: { (success) in
                
                if success {
                    
                    self.refresh()
                    if(self.timeTest==1){
                        self.timeTest=0
                        imageView.removeFromSuperview()
                        
                        self.refreshButton.isEnabled=true
                    }
                } else {
                    print("Zipcode was unable to get the subthoroughfare")
                }
                
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self                                 //code for blue circle and coordinates of user
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        
        if Reachability.isConnectedToNetwork() == false {
            
            errorCluba()
        }
        else{
            UserService.show(forUID: User.current.uid) { (user) in
                if let user = user {
                    self.name = user.club
                    if(self.name==""){
                        self.switcha.isHidden=true
                    }
                    else{
                        self.switcha.isHidden=false
                    }
                    
                } else {
                    // HANDLE ERROR: COULD NOT RETRIEVE USER
                }
            }
            
            zipcode(completion: { (success) in
                
                if success {
                    self.retrieveFromFire() { (success) in
                        
                        self.refresh()
                        
                        UserDefaults.standard.set(self.city, forKey: "zip")
                    }
                } else {
                    print("Zipcode was unable to get the subthoroughfare")
                }
                
            })
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() == false {
            
            errorCluba()
        }
        else{
            UserService.show(forUID: User.current.uid) { (user) in
                if let user = user {
                    self.username = user.username
                    self.name = user.club
                    UserDefaults.standard.set(self.name, forKey: "club")
                    if(self.name==""){
                        self.switcha.isHidden=true
                    }
                    else{
                        self.switcha.isHidden=false
                    }
                    
                } else {
                    // HANDLE ERROR: COULD NOT RETRIEVE USER
                }
            }
            current.synchronize()
            

            zipcode(completion: { (success) in
                
                if success {
                    
                    self.refresh()
                    
                    
                } else {
                    print("Zipcode was unable to get the subthoroughfare")
                }
                
            })
            
            retrieveNumbersFromCreatePinClass()
            let coordinate = locationManager.location!.coordinate
            if(firstTest==0){
                print("firstTest == 0 case")
            }
            else{
                
                mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 500, 500), animated: true)
                if(testPinsCount==1){
                    UserDefaults.standard.set(0, forKey: "Test")
                    pinQuality=9.0
                    testPinsCount=0
                    errorTooClose()
                }
                else{
                    if(pinQuality==9.0){
                        print("9.0 case")
                    }
                    else if(pinType==""){
                        print("Blank case")
                        
                    }
                        
                    else{
                        let coordinate = locationManager.location!.coordinate
                        let lat = Double(coordinate.latitude)
                        let long = Double(coordinate.longitude)
                        let dictLocation: [AnyHashable : Any] = ["Latitude": lat, "Longitude": long]
                        counterOther=0
                        current.set(dictLocation, forKey: "coordinate1")
                        var pin = Pin(title:pinType!, subtitle:"Quality:\(pinQuality!)", longitude: long, latitude: lat)
                        
                        name=(UserDefaults.standard.object(forKey: "club") as! String ?? " ")
                        if(name==""){
                            
                            print("name == none")
                            
                        }
                            
                            
                        else {
                            ClubService.showClubsOnePin(name: name, username: User.current.uid, completion: { (pinCount)
                                in
                                
                                
                                self.clubPinsCount = pinCount
                                
                                ClubService.addPinToClub(longitude: long, latitude: lat, title: self.pinType!, subtitle: "Quality:\(self.pinQuality!)", name: self.name, username: User.current.uid, completion: { (pin) in
                                    return
                                    
                                })
                                ClubService.increaseClub(name: self.name, username: User.current.uid, pins: self.clubPinsCount)
                            })
                            
                        }
                        
                        print("It got here, and is calling zipcode.")
                        zipcode(completion: { (success) in
                            
                            print("Finished the zipcode function")
                            if success {
                                
                                self.retrieveNumbersFromCreatePinClass()
                                PinService.createPinAll(postal: self.city, longitude: long,latitude:lat, title: self.pinType!, subtitle:"Quality:\(self.pinQuality!)", completion:{ (pin) in
                                    
                                    print("yo this is inside createPinAll")
                                    return
                                })
                            } else {
                                print("Zipcode was unable to get the subthoroughfare")
                            }
                            
                        })
                        
                        PinService.createPin(longitude: long,latitude:lat, title: pinType!, subtitle:"Quality:\(pinQuality!)", completion:{ (pin) in
                            print("Create pin called succesfully")
                            return
                        })
                        
                        
                        if(pinQuality==10.0){
                            pin = Pin(title:pinType!, subtitle:"Quality:no ratings", longitude: long, latitude: lat)
                            counterOther = 1
                        }
                        else{
                        }
                        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        annotation.title = pinType!
                        if(counterOther == 1){
                            annotation.subtitle="Quality:no ratings"
                        }
                        else{
                            annotation.subtitle = ("Quality:\(pinQuality!)");
                        }
                        annotation.image = pinType!
                        if(pinType! == "Bathroom"){
                            
                        }
                        else if(pinType! == "Statue"){
                            
                        }
                        else if(pinType! == "Water Fountain"){
                            
                        }
                        else{
                            annotation.image = "other"
                        }
                        zipcode(completion: { (success) in
                            
                            if success {
                                
                                self.refresh()
                                
                            } else {
                                print("Zipcode was unable to get the subthoroughfare")
                            }
                            
                        })
                        mapView(mapView, viewFor: annotation)
                        UserDefaults.standard.set(0, forKey: "Test")
                        pinQuality=9.0
                        //creating the pin
                        
                    }
                }
            }
        }
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func waitForPins() {
        DispatchQueue.main.async {
            //            self.retrieveFromFire()
            
        }
    }
    
    func retrieveNumbersFromCreatePinClass(){               //func to retrive from the segments in the createMarkClass
        pinType=(UserDefaults.standard.object(forKey: "segmentType") as! String? ?? "")
        pinQuality=(UserDefaults.standard.object(forKey: "Quality") as! Double? ?? 9.0)
        firstTest=(UserDefaults.standard.object(forKey: "Test") as! Int? ?? 0)
    }
    
    
    func retrieveFromFire(success: @escaping (Bool) -> Void) {
        let dispatcher = DispatchGroup()
        dispatcher.enter()
        if(clubTest==1){
            PinService.showClub(name: name) { (pin) in
                if let pin = pin{
                    self.pins = pin
                    dispatcher.leave()
                }
                else{
                    print("not working")
                    return
                }
            }
            
        }
        else{
            PinService.showAll(postal: city) { (pin) in
                if let pin = pin{
                    self.pins = pin
                    dispatcher.leave()
                }
                else{
                    print("not working")
                    return
                }
            }
        }
        dispatcher.notify(queue: .main) {
            success(true)
            
            
        }
    }
    func refresh(){
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.removeAnnotations(mapView.annotations)
        self.pinsLength=self.pins.count
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        let coordinateCenter = self.locationManager.location!.coordinate
        let latCenter = Double(coordinateCenter.latitude)
        let longCenter = Double(coordinateCenter.longitude)
        
        self.retrieveFromFire() { (success) in
            if success {
                self.pinsLength=self.pins.count
                if(self.pins.count==0){
                    
                }
                else{
                    for x in 0...self.pins.count-1{
                        let distanceX = longCenter-self.pins[x].longitude!
                        let powerX = pow(distanceX,2.0)
                        let distanceY = latCenter-self.pins[x].latitude!
                        let powerY = pow (distanceY,2.0)
                        
                        if(powerX+powerY<0.000000000073)   {
                            self.testPinsCount = 1
                        }
                    }
                    
                }
                if(self.pinsLength==0){
                    self.timeTest=1
                }
                    
                    
                    
                    // AuthService.presentLogOut(viewController: self)- logout
                    
                else{
                    
                    self.pinsLength=self.pins.count
                    self.longitude=[]
                    self.latitude=[]
                    self.titlePin=[]
                    self.subtitle=[]
                    for i in 0...self.pinsLength-1{
                        
                        self.longitude.append(self.pins[i].longitude!)
                        
                        self.latitude.append(self.pins[i].latitude!)
                        
                        self.titlePin.append(self.pins[i].title!)
                        
                        self.subtitle.append(self.pins[i].subtitle!)
                    }
                    
                    
                    
                    
                    for x in 0...self.pinsLength-1{
                        let distanceX = longCenter-self.longitude[x]
                        let powerX = pow(distanceX,2.0)
                        let distanceY = latCenter-self.latitude[x]
                        let powerY = pow (distanceY,2.0)
                        
                        
                        
                        
                        if(powerX+powerY<=0.000149*Double(self.slider))   {
                            let annotation = CustomPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude[x], longitude: self.longitude[x])
                            annotation.title = self.titlePin[x]
                            
                            
                            
                            if(self.subtitle[x]=="Quality:no ratings"){
                                annotation.subtitle = ("Quality:no ratings")
                            }
                                
                                
                                
                            else{
                                annotation.subtitle = (self.subtitle[x])
                            }
                            
                            annotation.image = self.titlePin[x]
                            
                            if(self.titlePin[x] == "Bathroom"){
                                
                            }
                            else if(self.titlePin[x] == "Statue"){
                                
                            }
                            else if(self.titlePin[x] == "Water Fountain"){
                                
                            }
                            else{
                                annotation.image = "other"
                            }
                            self.mapView.addAnnotation(annotation)
                            //self.mapView(self.mapView, viewFor: annotation)
                            
                        }
                            
                            
                        else{
                            print("not in range")
                        }
                        
                        
                        
                        
                        if(x==self.pinsLength-1){
                            self.timeTest=1
                        }
                        
                    }
                    
                }
                self.pinsLength=self.pins.count
                
                self.locationManager.delegate = self
                self.locationManager.startUpdatingLocation()
                let coordinateCenter = self.locationManager.location!.coordinate
                
                
                self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinateCenter, 10+(10*Double(self.slider)),10+(10*Double(self.slider))), animated: true)
            }
        }
    }
    func zipcode(completion: @escaping (Bool) -> Void){
        let coordinate = locationManager.location!.coordinate
        let revLong = coordinate.longitude
        let revLat = coordinate.latitude
        let revCoordinate = CLLocation(latitude: revLat,longitude: revLong)
        CLGeocoder().reverseGeocodeLocation(revCoordinate) { (placemark, error) in
            if error != nil
            {
                print("error")
                completion(false)
            }
            else{
                
                if let place = placemark?[0]
                {
                    
                    if place.subThoroughfare != nil{
                        self.city = place.postalCode!
                        print(self.city)
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                } else {
                    completion(false)
                }
            }
        }
        
    }
    func errorCluba(){
        let invalidMoneyAlerta = UIAlertController(title: "Internet Connnection is bad", message: "Please turn on your internet services", preferredStyle: UIAlertControllerStyle.alert)
        invalidMoneyAlerta.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: {action -> Void in
            exit(0)
        }))
        self.present(invalidMoneyAlerta, animated:true,completion:nil)
    }
    func errorTooClose(){
        let invalidMoneyAlerta = UIAlertController(title: "pins too cluttered", message: "Please dont put pins too close to other pins", preferredStyle: UIAlertControllerStyle.alert)
        invalidMoneyAlerta.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: {action -> Void in
        }))
        self.present(invalidMoneyAlerta, animated:true,completion:nil)
    }
    func report(){
        let invalidMoneyAlerta = UIAlertController(title: "are you sure you want to report this pins", message: "If your report is false you will be penalized", preferredStyle: UIAlertControllerStyle.alert)
        invalidMoneyAlerta.addAction(UIAlertAction(title: "yes", style: UIAlertActionStyle.default, handler: {action -> Void in
            let coordinate = self.locationManager.location!.coordinate
            let revLong = coordinate.longitude
            let revLat = coordinate.latitude
            let userInClubReference = Database.database().reference().child("Reports").childByAutoId()
            userInClubReference.setValue("\(revLong)+\(revLat)")
        }))
        invalidMoneyAlerta.addAction(UIAlertAction(title: "no", style: UIAlertActionStyle.default, handler: {action -> Void in
            print("hi")
        }))
        self.present(invalidMoneyAlerta, animated:true,completion:nil)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "mapIdentifier")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "mapIdentifier")
            
        }
            
        else {
            let imageNameRight = "earth.png"
            let imageRight = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            let imageViewRight = UIImage(named:imageNameRight)
            imageRight.setImage(imageViewRight, for: .normal)
            annotationView!.canShowCallout = true
            
            annotationView!.rightCalloutAccessoryView = imageRight
            annotationView!.annotation = annotation
        }
        
        let cpa = annotation as! CustomPointAnnotation
        annotationView!.image = UIImage(named: cpa.image)!
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let dankView = view.annotation as? MKPointAnnotation
            report()
            
        }
    }
}






extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateEarth = CABasicAnimation(keyPath: "transform.rotation")
        rotateEarth.fromValue = 0.0
        rotateEarth.toValue = CGFloat(M_PI * 2.0)
        rotateEarth.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateEarth.delegate = delegate as! CAAnimationDelegate
        }
        self.layer.add(rotateEarth, forKey: nil)
        
        
        
    }
}


extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}


