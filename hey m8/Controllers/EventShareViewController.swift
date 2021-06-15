//
//  EventShareViewController.swift
//  hey m8
//
//  Created by Christina Li on 15/6/21.
//

import UIKit

class EventShareViewController: UIViewController {

    @IBOutlet weak var QRCode: UIImageView!
    @IBOutlet weak var shareCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        QRCode.image = generateQRCode(from: <#T##String#>)
//        QRCode =

        // Do any additional setup after loading the view.
    }
    

//    func generateQRCode() {
//        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
//        let qrData = absoluteString.data(using: String.Encoding.ascii)
//        qrFilter.setValue(qrData, forKey: "inputMessage")
//
//        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
//        let qrImage = qrFilter.outputImage?.transformed(by: qrTransform)
//
//    }
//
    
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
