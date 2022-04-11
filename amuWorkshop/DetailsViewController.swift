//
//  DetailsViewController.swift
//  amuWorkshop
//
//  Created by Simona Malevska on 12/12/21.
//  Copyright © 2021 Simona Malevska. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var opis: UILabel!
    @IBOutlet weak var datum: UILabel!
    @IBOutlet weak var frek: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var imepLabel: UILabel!
    @IBOutlet weak var imePrezime: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var voTek: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var telefon: UILabel!
    @IBOutlet weak var rejting: UILabel!
    @IBOutlet weak var eden: UIButton!
    @IBOutlet weak var dva: UIButton!
    @IBOutlet weak var tri: UIButton!
    @IBOutlet weak var cetiri: UIButton!
    @IBOutlet weak var pet: UIButton!
    @IBOutlet weak var prifatiButton: UIButton!
    @IBOutlet weak var otkaziButton: UIButton!
    @IBOutlet weak var odbijButton: UIButton!
    
    var request = Dictionary<String, AnyObject>()
    
    @IBAction func prifati(_ sender: Any) {
        Database.database().reference().child("Requests").queryOrdered(byChild: "id").queryEqual(toValue: request["id"]).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["status": "Закажана задача"])
        }
        status.text = "Закажана задача"
        prifatiButton.isHidden = true
        odbijButton.isHidden = true
        otkaziButton.isHidden = true
        voTek.isHidden = false
    }
    
    @IBAction func otkazi(_ sender: Any) {
        if otkaziButton.titleLabel?.text == "Испрати извештај" {
            performSegue(withIdentifier: "izvestajKSegue", sender: nil)
        }
        else {
            Database.database().reference().child("Requests").queryOrdered(byChild: "id").queryEqual(toValue: request["id"]).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["status": "Откажана задача"])
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func odbij(_ sender: Any) {
        Database.database().reference().child("Requests").queryOrdered(byChild: "id").queryEqual(toValue: request["id"]).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["status": "Активно барање"])
        }
        status.text = "Активно барање"
        imepLabel.isHidden = true
        imePrezime.isHidden = true
        mailLabel.isHidden = true
        mail.isHidden = true
        telLabel.isHidden = true
        telefon.isHidden = true
        rejting.isHidden = true
        eden.isHidden = true
        dva.isHidden = true
        tri.isHidden = true
        cetiri.isHidden = true
        pet.isHidden = true
        prifatiButton.isHidden = true
        odbijButton.isHidden = true
        voTek.isHidden = true
        otkaziButton.isHidden = false
        otkaziButton.setTitle("Откажи", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let type = request["tip"] as? String {
            tip.text = type
        }
        
        if let desc = request["opis"] as? String {
            opis.text = desc
        }
        
        if let frekv = request["frek"] as? String {
            frek.text = frekv
        }
        
        if let date = request["datum"] as? String {
            if request["itnost"] as? String == "da" {
                datum.text = "Итно барање"
            } else {
                datum.text = date
            }
        }
        if let stat = request["status"] as? String {
            status.text = stat
            if stat == "Активно барање" {
                imepLabel.isHidden = true
                imePrezime.isHidden = true
                mailLabel.isHidden = true
                mail.isHidden = true
                telLabel.isHidden = true
                telefon.isHidden = true
                rejting.isHidden = true
                eden.isHidden = true
                dva.isHidden = true
                tri.isHidden = true
                cetiri.isHidden = true
                pet.isHidden = true
                prifatiButton.isHidden = true
                odbijButton.isHidden = true
                voTek.isHidden = true
                otkaziButton.isHidden = false
                otkaziButton.setTitle("Откажи", for: .normal)
            }
            
            if stat == "Пријавен волонтер" {
                imepLabel.isHidden = false
                imePrezime.isHidden = false
                if let imeV = request["imeVol"] as? String {
                    imePrezime.text = imeV
                }
                mailLabel.isHidden = false
                mail.isHidden = false
                if let mailV = request["emailVol"] as? String {
                    mail.text = mailV
                }
                telLabel.isHidden = false
                telefon.isHidden = false
                if let telV = request["phoneVol"] as? String {
                    telefon.text = telV
                }
                rejting.isHidden = false
                eden.isHidden = false
                dva.isHidden = false
                tri.isHidden = false
                cetiri.isHidden = false
                pet.isHidden = false
                
                prifatiButton.isHidden = false
                odbijButton.isHidden = false
                voTek.isHidden = true
                otkaziButton.isHidden = true
            }
            
            if stat == "Закажана задача" {
                imepLabel.isHidden = false
                imePrezime.isHidden = false
                if let imeV = request["imeVol"] as? String {
                    imePrezime.text = imeV
                }
                mailLabel.isHidden = false
                mail.isHidden = false
                if let mailV = request["email"] as? String {
                    mail.text = mailV
                }
                telLabel.isHidden = false
                telefon.isHidden = false
                if let telV = request["phone"] as? String {
                    telefon.text = telV
                }
                rejting.isHidden = false
                eden.isHidden = false
                dva.isHidden = false
                tri.isHidden = false
                cetiri.isHidden = false
                pet.isHidden = false
                
                prifatiButton.isHidden = true
                odbijButton.isHidden = true
                voTek.isHidden = false
                otkaziButton.isHidden = true
            }
            
            if stat == "Завршена задача" {
                otkaziButton.setTitle("Испрати извештај", for: .normal)
                prifatiButton.isHidden = true
                odbijButton.isHidden = true
                voTek.isHidden = true
                
                imepLabel.isHidden = false
                imePrezime.isHidden = false
                if let imeV = request["imeVol"] as? String {
                    imePrezime.text = imeV
                }
                mailLabel.isHidden = false
                mail.isHidden = false
                if let mailV = request["email"] as? String {
                    mail.text = mailV
                }
                telLabel.isHidden = false
                telefon.isHidden = false
                if let telV = request["phone"] as? String {
                    telefon.text = telV
                }
                
            }
            
            if stat != "Активно барање" {
                let rejting = request["rejtingZaVolonter"] as! Int
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
            }
        }
        
        Database.database().reference().child("Requests").observe(.childChanged) { (snapshot) in
            if let actReqDictionary = snapshot.value as? [String : AnyObject] {
                if let id = actReqDictionary["id"] as? String {
                    if id == self.request["id"] as? String {
                        if actReqDictionary["status"] as? String == "Пријавен волонтер" {
                            self.status.text = "Пријавен волонтер"
                            self.imepLabel.isHidden = false
                            self.imePrezime.isHidden = false
                            if let imeV = self.request["imeVol"] as? String {
                                self.imePrezime.text = imeV
                            }
                            self.mailLabel.isHidden = false
                            self.mail.isHidden = false
                            if let mailV = self.request["emailVol"] as? String {
                                self.mail.text = mailV
                            }
                            self.telLabel.isHidden = false
                            self.telefon.isHidden = false
                            if let telV = self.request["phoneVol"] as? String {
                                self.telefon.text = telV
                            }
                            self.rejting.isHidden = false
                            
                            self.prifatiButton.isHidden = false
                            self.odbijButton.isHidden = false
                            self.voTek.isHidden = true
                            self.otkaziButton.isHidden = true
                        }
                        
                        if actReqDictionary["status"] as? String == "Завршена задача" {
                            self.status.text = "Завршена задача"
                            self.otkaziButton.setTitle("Испрати извештај", for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let acceptVC = segue.destination as? IzvestajKlientViewController {
            acceptVC.request = request
        }
    }
}
