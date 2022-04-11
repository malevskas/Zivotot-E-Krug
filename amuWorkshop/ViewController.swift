//
//  ViewController.swift
//  amuWorkshop
//
//  Created by Simona Malevska on 12/4/21.
//  Copyright © 2021 Simona Malevska. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var editB: UIButton!
    @IBOutlet weak var change: UISwitch!
    @IBOutlet weak var k: UIButton!
    @IBOutlet weak var v: UIButton!
    
    var type = ""
    var mode = true // switch on
    let customGreen = UIColor(red: 0/255.0, green: 172/255.0, blue: 173/255.0, alpha: 1.0)
    let customCream = UIColor(red: 249/255.0, green: 238/255.0, blue: 232/255.0, alpha: 1.0)
    
    @IBAction func volonter(_ sender: Any) {
        type = "volonter"
        v.backgroundColor = customGreen
        v.setTitleColor(customCream, for: .normal)
        k.backgroundColor = customCream
        k.setTitleColor(customGreen, for: .normal)
    }
    
    @IBAction func klient(_ sender: Any) {
        type = "klient"
        k.backgroundColor = customGreen
        k.setTitleColor(customCream, for: .normal)
        v.backgroundColor = customCream
        v.setTitleColor(customGreen, for: .normal)
    }

    @IBAction func button(_ sender: Any) {
        if mail.text == "" || password.text == "" {
            displayAlert(title: "Недостасуваат информации!", msg: "Ве молиме проверете.")
        } else {
            if let email = mail.text {
                if let pass = password.text {
                    if mode { // registracija
                       
                       print("registracija")
                        Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Грешка!", msg: error!.localizedDescription)
                            } else {
                                if self.type != "" {
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = self.type
                                    req?.commitChanges(completion: nil)
                                    let reqDictionary = ["adresa": email as String, "fullname": self.fullname.text!, "phone": self.phone.text!, "rejting": 0] as [String : Any]
                                    Database.database().reference().child("Users").childByAutoId().setValue(reqDictionary)
                                }
                                if self.type == "volonter" {
                                    self.performSegue(withIdentifier: "volonterSegue", sender: nil)
                                }
                                if self.type == "klient" {
                                    self.performSegue(withIdentifier: "klientSegue", sender: nil)
                                }
                            }
                        }
                    } else { // najava
                        print("najava")
                        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Грешка!", msg: error!.localizedDescription)
                            } else {
                                if user?.user.displayName == "volonter" {
                                    self.performSegue(withIdentifier: "volonterSegue", sender: nil)
                                }
                                if user?.user.displayName == "klient" {
                                    self.performSegue(withIdentifier: "klientSegue", sender: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func edit(_ sender: Any) {
        if change.isOn { // registracija
            mode = true
            editB.setTitle("Регистрирај се!", for: .normal)
            fullname.isHidden = false
            phone.isHidden = false
            v.isHidden = false
            k.isHidden = false
        } else { // najava
            mode = false
            editB.setTitle("Најави се!", for: .normal)
            fullname.isHidden = true
            phone.isHidden = true
            v.isHidden = true
            k.isHidden = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode = false
        editB.setTitle("Најави се!", for: .normal)
        fullname.isHidden = true
        phone.isHidden = true
        v.isHidden = true
        k.isHidden = true
        change.setOn(false, animated: true)
    }

    func displayAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
