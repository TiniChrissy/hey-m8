//
//  EventsViewController.swift
//  hey m8
//
//  Created by Christina Li on 2/5/21.
//

import UIKit
import Firebase

class EventsViewController: UIViewController {

    var docRef:DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //move this
//    func loadData() {
//        let eventsRef = database.collection("events")
//        eventsRef.addSnapshotListener { (querySnapshot, error) in
//            guard let querySnapshot = querySnapshot else {
//                os_log("No query snapshot")
//                return
//            }
//            
//            querySnapshot.documentChanges.forEach { (diff) in
//                let id = diff.document.documentID
//                if let name = diff.document.data()["name"],let description = diff.document.data()["description"] {
//                    os_log("DO SOMETHING WITH THE DATA ")
//                }
//            }
//        }
//    }
//    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
