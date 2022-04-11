//
//  ReqDetViewController.swift
//  amuWorkshop
//
//  Created by Simona Malevska on 12/19/21.
//  Copyright © 2021 Simona Malevska. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseAuth
import FirebaseDatabase

class ReqDetViewController: UIViewController, CLLocationManagerDelegate {
    
    var request = Dictionary<String, AnyObject>()
    var name = ""
    var phone = ""
    var rejting = 0
    var count = 0
    var vkupno = 0
    var locationManager = CLLocationManager()
    var myLocation = CLLocationCoordinate2D()
    let customBlue = UIColor(red: 0/255.0, green: 129/255.0, blue: 198/255.0, alpha: 1.0)
    let customPink = UIColor(red: 255/255.0, green: 63/255.0, blue: 88/255.0, alpha: 1.0)
    
    @IBOutlet weak var imePrezime: UILabel!
    @IBOutlet weak var datum: UILabel!
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var rastojanie: UILabel!
    @IBOutlet weak var eden: UIButton!
    @IBOutlet weak var dva: UIButton!
    @IBOutlet weak var tri: UIButton!
    @IBOutlet weak var cetiri: UIButton!
    @IBOutlet weak var pet: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var telefon: UILabel!
    @IBOutlet weak var kopce: UIButton!
    
    @IBAction func prifati(_ sender: Any) {
        if kopce.titleLabel?.text == "Испрати извештај" {
            performSegue(withIdentifier: "izvestajVSegue", sender: nil)
        }

        if request["status"] as? String == "Активно барање" {
            if let mail = Auth.auth().currentUser?.email {
                
                Database.database().reference().child("Requests").queryOrdered(byChild: "id").queryEqual(toValue: request["id"]).observe(.childAdded) { (snapshot) in
                    snapshot.ref.updateChildValues(["status": "Пријавен волонтер", "imeVol": self.name, "emailVol": mail, "phoneVol": self.phone, "rejtingZaVolonter": self.rejting])
                }
            }
            
            kopce.setTitle("Се чека одговор...", for: .normal)
            kopce.setTitleColor(customPink, for: .normal)
        }
        
        if request["status"] as? String == "Закажана задача" {
            Database.database().reference().child("Requests").queryOrdered(byChild: "id").queryEqual(toValue: request["id"]).observe(.childAdded) { (snapshot) in
                snapshot.ref.updateChildValues(["status": "Завршена задача"])
            }
            kopce.setTitle("Испрати извештај", for: .normal)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ime = request["fullname"] as? String {
            imePrezime.text = ime
        }
        
        if let type = request["tip"] as? String {
            tip.text = type
        }
        
        if let date = request["datum"] as? String {
            if request["itnost"] as? String == "da" {
                datum.text = "Итно барање"
            } else {
                datum.text = date
            }
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let rejting = request["rejtingZaKlient"] as! Int
        if rejting == 0 {
                eden.setImage(UIImage(systemName: "star"), for: .normal)
                dva.setImage(UIImage(systemName: "star"), for: .normal)
                tri.setImage(UIImage(systemName: "star"), for: .normal)
                cetiri.setImage(UIImage(systemName: "star"), for: .normal)
                pet.setImage(UIImage(systemName: "star"), for: .normal)
            } else if rejting <= 1 {
                eden.setImage(UIImage(systemName: "star.fill"), for: .normal)
                dva.setImage(UIImage(systemName: "star"), for: .normal)
                tri.setImage(UIImage(systemName: "star"), for: .normal)
                cetiri.setImage(UIImage(systemName: "star"), for: .normal)
                pet.setImage(UIImage(systemName: "star"), for: .normal)
            }  else if rejting <= 2 {
                eden.setImage(UIImage(systemName: "star.fill"), for: .normal)
                dva.setImage(UIImage(systemName: "star.fill"), for: .normal)
                tri.setImage(UIImage(systemName: "star"), for: .normal)
                cetiri.setImage(UIImage(systemName: "star"), for: .normal)
                pet.setImage(UIImage(systemName: "star"), for: .normal)
            } else if rejting <= 3 {
                eden.setImage(UIImage(systemName: "star.fill"), for: .normal)
                dva.setImage(UIImage(systemName: "star.fill"), for: .normal)
                tri.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cetiri.setImage(UIImage(systemName: "star"), for: .normal)
                pet.setImage(UIImage(systemName: "star"), for: .normal)
            } else if rejting <= 4 {
                eden.setImage(UIImage(systemName: "star.fill"), for: .normal)
                dva.setImage(UIImage(systemName: "star.fill"), for: .normal)
                tri.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cetiri.setImage(UIImage(systemName: "star.fill"), for: .normal)
                pet.setImage(UIImage(systemName: "star"), for: .normal)
            }  else {
                eden.setImage(UIImage(systemName: "star.fill"), for: .normal)
                dva.setImage(UIImage(systemName: "star.fill"), for: .normal)
                tri.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cetiri.setImage(UIImage(systemName: "star.fill"), for: .normal)
                pet.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
        
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("Users").queryOrdered(byChild: "adresa").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
                if let usersDictionary = snapshot.value as? [String: AnyObject] {
                    if let name = usersDictionary["fullname"] as? String {
                        self.name = name
                    }
                    if let phone = usersDictionary["phone"] as? String {
                        self.phone = phone
                    }
                    if let rejting = usersDictionary["rejting"] as? Int {
                        self.rejting = rejting
                    }
                }
            }
        }
        
        if let lat = request["lat"] as? Double {
            if let lon = request["lon"] as? Double {
                let volCLLocation = CLLocation(latitude: myLocation.latitude, longitude: myLocation.longitude)
                let clientLocation = CLLocation(latitude: lat, longitude: lon)
                let distance = volCLLocation.distance(from: clientLocation) / 1000
                let roundedDistance = round(distance*100) / 100
                rastojanie.text = "\(roundedDistance) km"
            }
        }
        
        if request["status"] as? String == "Активно барање" {
            emailLabel.isHidden = true
            email.isHidden = true
            telLabel.isHidden = true
            telefon.isHidden = true
            kopce.setTitle("Прифати", for: .normal)
            kopce.setTitleColor(customBlue, for: .normal)
        }
        
        /*if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("Requests").observe(.childChanged) { (snapshot) in
                if let dict = snapshot.value as? [String : AnyObject] {
                    if email == dict["emailVol"] as? String {
                        if dict["status"] as? String == "Завршена задача" {
                            self.count = self.count + 1
                            let n = dict["rejtingZaVolonter"] as! Double
                            self.vkupno = self.vkupno + n
                        }
                    }
                }
            }
        }
        
        rejting = vkupno / count
        Database.database().reference().child("Users").queryOrdered(byChild: "adresa").queryEqual(toValue: request["emailVol"]).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["rejting": self.rejting])}*/
        
        if request["status"] as? String == "Пријавен волонтер" {
            emailLabel.isHidden = true
            email.isHidden = true
            telLabel.isHidden = true
            telefon.isHidden = true
            kopce.setTitle("Се чека одговор...", for: .normal)
            kopce.setTitleColor(customPink, for: .normal)
        }
        
        if request["status"] as? String == "Закажана задача" {
            emailLabel.isHidden = false
            email.isHidden = false
            telLabel.isHidden = false
            telefon.isHidden = false
            email.text = request["email"] as? String
            telefon.text = request["phone"] as? String
            kopce.setTitle("Заврши барање", for: .normal)
            kopce.setTitleColor(customBlue, for: .normal)
        }
        
        Database.database().reference().child("Requests").observe(.childChanged) { (snapshot) in
            if let actReqDictionary = snapshot.value as? [String : AnyObject] {
                if let id = actReqDictionary["id"] as? String {
                    if id == self.request["id"] as? String {
                        if actReqDictionary["status"] as? String == "Активно барање" {
                            self.emailLabel.isHidden = true
                            self.email.isHidden = true
                            self.telLabel.isHidden = true
                            self.telefon.isHidden = true
                            self.kopce.setTitle("Прифати", for: .normal)
                            self.kopce.setTitleColor(self.customBlue, for: .normal)
                        }
                        
                        if actReqDictionary["status"] as? String == "Закажана задача" {
                            self.emailLabel.isHidden = false
                            self.email.isHidden = false
                            self.telLabel.isHidden = false
                            self.telefon.isHidden = false
                            self.email.text = self.request["email"] as? String
                            self.telefon.text = self.request["phone"] as? String
                            self.kopce.setTitle("Заврши барање", for: .normal)
                            self.kopce.setTitleColor(self.customBlue, for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            myLocation = coord
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let acceptVC = segue.destination as? IzvestajVolonterViewController {
            acceptVC.request = request
        }
    }

    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
