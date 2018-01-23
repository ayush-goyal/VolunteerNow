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
        
        guard let id = User.uid else { fatalError() }
        let data = id.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        let qrcodeImage: CIImage = filter.outputImage!
        
        let scaleX = qrImageView.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = qrImageView.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        qrImageView.image = UIImage(ciImage: transformedImage)
    }
    
    @IBAction func switchToOrganizationView(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "organizationSignInController")
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
