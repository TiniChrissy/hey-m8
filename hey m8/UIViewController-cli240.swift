//
//  UIViewController-cli240.swift
//  Week 1
//
//  Created by user181294 on 3/12/21.
//

import Foundation
import UIKit

extension UIViewController{
    func displayMessagecli240(title:String, message:String) {
        let alertController = UIAlertController(title: title, message:  message,preferredStyle: .alert)
    
        alertController.addAction(UIAlertAction(title: "Dismiss", style:.default,handler: nil))
    
        self.present(alertController, animated: true, completion: nil)
    }
}
