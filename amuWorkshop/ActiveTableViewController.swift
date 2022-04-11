//
//  ActiveTableViewController.swift
//  amuWorkshop
//
//  Created by Simona Malevska on 12/10/21.
//  Copyright © 2021 Simona Malevska. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ActiveTableViewController: UITableViewController {
    
    var activeRequests = [Dictionary<String, AnyObject>()]
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activeRequests.remove(at: 0)
        Database.database().reference().child("Requests").observe(.childAdded) { (snapshot) in
            if let activeReqDictionary = snapshot.value as? [String: AnyObject] {
                if let mail = activeReqDictionary["email"] as? String {
                    if let myMail = Auth.auth().currentUser?.email {
                        if myMail == mail {
                            self.activeRequests.append(activeReqDictionary)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
        Database.database().reference().child("Requests").observe(.childChanged) { (snapshot) in
            if let actReqDictionary = snapshot.value as? [String : AnyObject] {
                if let id = actReqDictionary["id"] as? String {
                    for i in 0..<self.activeRequests.count {
                        if let reqID = self.activeRequests[i]["id"] as? String {
                            if reqID == id {
                                self.activeRequests[i] = actReqDictionary
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeRequests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeCell", for: indexPath)
        
        let activeReqDict = activeRequests[indexPath.row]
        if let type = activeReqDict["tip"] as? String {
                cell.textLabel?.text = type
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        let activeRequest = activeRequests[indexPath.row]
        performSegue(withIdentifier: "detailsSegue", sender: activeRequest)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let acceptVC = segue.destination as? DetailsViewController {
            acceptVC.request = activeRequests[index]
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
