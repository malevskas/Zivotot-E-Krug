//
//  ClientViewController.swift
//  amuWorkshop
//
//  Created by Simona Malevska on 12/9/21.
//  Copyright © 2021 Simona Malevska. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase

class ClientViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var nedelno: UIButton!
    @IBOutlet weak var datum: UITextField!
    @IBOutlet weak var ednokratno: UIButton!
    @IBOutlet weak var check: UIButton!
    var clicked = "ne"
    var frek = "" // nedelno
    var count: UInt = 0
    var fullname = ""
    var phone = ""
    var rejting = 0
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    let customGreen = UIColor(red: 0/255.0, green: 172/255.0, blue: 173/255.0, alpha: 1.0)
    
    @IBAction func itno(_ sender: Any) {
        if clicked == "da" {
            clicked = "ne"
            check.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            clicked = "da"
            check.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        }
    }

    @IBAction func ednoClick(_ sender: Any) {
        frek = "Еднократно"
        ednokratno.backgroundColor = customGreen
        ednokratno.setTitleColor(UIColor.white, for: .normal)
        nedelno.backgroundColor = UIColor.white
        nedelno.setTitleColor(customGreen, for: .normal)
    }
    
    @IBAction func nedClick(_ sender: Any) {
        frek = "Неделно"
        nedelno.backgroundColor = customGreen
        nedelno.setTitleColor(UIColor.white, for: .normal)
        ednokratno.backgroundColor = UIColor.white
        ednokratno.setTitleColor(customGreen, for: .normal)
    }
    
    @IBAction func zacuvaj(_ sender: Any) {
        if let email = Auth.auth().currentUser?.email{
            let ref = Database.database().reference().child("Requests")
            ref.observe(.value, with: { (snapshot) in
                self.count = snapshot.childrenCount
            })
            print(email)
            
            let reqDictionary = ["email": email, "fullname": self.fullname, "phone": self.phone, "rejtingZaKlient": rejting, "frek": self.frek, "itnost": self.clicked, "status": "Активно барање", "id": self.count, "tip": self.type.text!, "datum": datum.text!, "opis": self.desc.text!, "lat": self.userLocation.latitude, "lon": self.userLocation.longitude] as [String : Any]
            Database.database().reference().child("Requests").childByAutoId().setValue(reqDictionary)
            
            type.text = ""
            desc.text = ""
            nedelno.backgroundColor = UIColor.white
            nedelno.setTitleColor(customGreen, for: .normal)
            ednokratno.backgroundColor = UIColor.white
            ednokratno.setTitleColor(customGreen, for: .normal)
            clicked = "ne"
            check.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
    }
    
    @IBAction func lokacija(_ sender: Any) {
        performSegue(withIdentifier: "locationSegue", sender: nil)
    }
    
    @IBAction func aktivni(_ sender: Any) {
        performSegue(withIdentifier: "activeSegue", sender: nil)
    }
    
    @IBAction func odjava(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func dateChange(datePicker: UIDatePicker){
        datum.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter.string(from: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        //datePicker.preferredDatePickerStyle = .wheels
        datum.inputView = datePicker
        datum.text = formatDate(date: Date())
        
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("Users").queryOrdered(byChild: "adresa").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                if let dict = snapshot.value as? [String: Any] {
                    if let name = dict["fullname"] as? String {
                        self.fullname = name
                    }
                    if let phone = dict["phone"] as? String {
                        self.phone = phone
                    }
                    if let rejting = dict["rejting"] as? Int {
                        self.rejting = rejting
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
        }
    }
}
