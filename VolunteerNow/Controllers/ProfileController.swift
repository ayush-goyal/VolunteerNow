//
//  ProfileController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class ProfileController: UITableViewController {

    @IBOutlet weak var qrImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQrCode()
    }
    
    func setupQrCode() {
        let filter: CIFilter = CIFilter(name: "CIQRCodeGenerator")!
        
        let defaults = UserDefaults.standard
        let id = String(defaults.integer(forKey: "id"))
        let data = id.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        let qrcodeImage: CIImage = filter.outputImage!
        
        let scaleX = qrImageView.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = qrImageView.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        qrImageView.image = UIImage(ciImage: transformedImage)
    }

}
