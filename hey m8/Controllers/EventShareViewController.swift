//
//  EventShareViewController.swift
//  hey m8
//
//  Created by Christina Li on 15/6/21.
//
// Working QR Code https://www.hackingwithswift.com/example-code/media/how-to-create-a-qr-code
// Colour tint not working code https://www.avanderlee.com/swift/qr-code-generation-swift/

import UIKit

class EventShareViewController: UIViewController {
    
    @IBOutlet weak var QRCode: UIImageView!
    @IBOutlet weak var shareCode: UILabel!
    
    @IBAction func goBackToMainEventPage(_ sender: Any) {
        
        let userEventsViewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3] as? UserEventsTableViewController
        self.navigationController?.popToViewController(userEventsViewController!, animated: true)
        
    }
    weak var eventDelegate: CreateEventViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background Colour")
        let code = eventDelegate?.eventID
        if ((code) != nil) {
            let tempCode = generateQRCode(from: (eventDelegate?.eventID)!)
            QRCode.image = tempCode
            shareCode.text = String(code?.prefix(4) ?? "")
        }
    }
    
    func generateQRCode(from input: String) -> UIImage? {
        let data = input.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
}
