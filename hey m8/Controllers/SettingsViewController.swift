//
//  SettingsViewController.swift
//  hey m8
//
//  Created by Christina Li on 2/6/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background Colour")
        textView.isEditable = false
    }

}
