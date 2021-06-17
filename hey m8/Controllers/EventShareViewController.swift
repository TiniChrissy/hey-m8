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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
