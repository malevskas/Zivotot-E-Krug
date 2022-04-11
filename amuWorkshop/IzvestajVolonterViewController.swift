//
//  IzvestajVolonterViewController.swift
//  amuWorkshop
//
//  Created by Simona Malevska on 12/28/21.
//  Copyright © 2021 Simona Malevska. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class IzvestajVolonterViewController: UIViewController {
    
    var request = Dictionary<String, AnyObject>()
    var ocenka = 0
    var count = 0
    var vkupno = 0
    var rejting = 0
    @IBOutlet weak var textF: UITextField!
    @IBOutlet weak var eden: UIButton!
    @IBOutlet weak var dva: UIButton!
    @IBOutlet weak var tri: UIButton!
    @IBOutlet weak var cetiri: UIButton!
    @IBOutlet weak var pet: UIButton!
    
    @IBAction func one(_ sender: Any) {
        ocenka = 1
        eden.setImage(UIImage(systemName: "star.fill"), for: .normal)
        dva.setImage(UIImage(systemName: "star"), for: .normal)
        tri.setImage(UIImage(systemName: "star"), for: .normal)
        cetiri.setImage(UIImage(systemName: "star"), for: .normal)
        pet.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    @IBAction func two(_ sender: Any) {
        ocenka = 2
        eden.setImage(UIImage(systemName: "star.fill"), for: .normal)
        dva.setImage(UIImage(systemName: "star.fill"), for: .normal)
        tri.setImage(UIImage(systemName: "star"), for: .normal)
        cetiri.setImage(UIImage(systemName: "star"), for: .normal)
        pet.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    @IBAction func three(_ sender: Any) {
        ocenka = 3
        eden.setImage(UIImage(systemName: "star.fill"), for: .normal)
        dva.setImage(UIImage(systemName: "star.fill"), for: .normal)
        tri.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cetiri.setImage(UIImage(systemName: "star"), for: .normal)
        pet.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    @IBAction func four(_ sender: Any) {
        ocenka = 4
        eden.setImage(UIImage(systemName: "star.fill"), for: .normal)
        dva.setImage(UIImage(systemName: "star.fill"), for: .normal)
        tri.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cetiri.setImage(UIImage(systemName: "star.fill"), for: .normal)
        pet.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    @IBAction func five(_ sender: Any) {
        ocenka = 5
        eden.setImage(UIImage(systemName: "star.fill"), for: .normal)
        dva.setImage(UIImage(systemName: "star.fill"), for: .normal)
        tri.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cetiri.setImage(UIImage(systemName: "star.fill"), for: .normal)
        pet.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    @IBAction func isprati(_ sender: Any) {
        Database.database().reference().child("Requests").queryOrdered(byChild: "id").queryEqual(toValue: request["id"]).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["izvestajZaKlient": self.textF.text!, "rejtingZaKlient": self.ocenka])}
        
        rejting = (vkupno + ocenka) / (count + 1)
        print(rejting)
        Database.database().reference().child("Users").queryOrdered(byChild: "adresa").queryEqual(toValue: request["email"]).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["rejting": self.rejting])}
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("Requests").observe(.childAdded) { (snapshot) in
                if let dict = snapshot.value as? [String : AnyObject] {
                    if email == dict["email"] as? String {
                        if dict["status"] as? String == "Завршена задача" {
                            self.count = self.count + 1
                            print(self.count)
                            let n = dict["rejtingZaKlient"] as! Int
                            print(n)
                            self.vkupno = self.vkupno + n
                            print(self.vkupno)
                        }
                    }
                }
            }
        }
    }
}
