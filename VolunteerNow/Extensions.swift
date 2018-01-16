//
//  Extensions.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/15/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

let eventImageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        self.image = nil // Prevents images from flashing when scrolling
        
        guard let url = NSURL(string: link) else { return }
        
        // Check for cached image first
        if let cachedImage = eventImageCache.object(forKey: url) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // Otherwise request image
        let urlRequest = URLRequest(url: url as URL)
        contentMode = mode

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            print("RETRIEVING IMAGE\n")
            print(error?.localizedDescription)
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            print("SETTING IMAGE\n")
            DispatchQueue.main.async() {
                eventImageCache.setObject(image, forKey: url)
                self.image = image
                self.addImageTint(withColor: UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.4))
                self.superview?.sendSubview(toBack: self)
                return
            }
        }
        task.resume()
    }
    
    func addImageTint(withColor tintColor: UIColor) {
        let tintOverlayView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        tintOverlayView.backgroundColor = tintColor
        self.addSubview(tintOverlayView)
    }
}

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: -3, height: 3)
        self.layer.shadowRadius = 4
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.masksToBounds = false
    }
}


extension UIColor {
    struct Custom {
        static let darkGray = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
        static let lightGray = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1)
        static let backgroundGray = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        static let purple = UIColor(red: 96/255, green: 77/255, blue: 198/255, alpha: 1)
    }
}

extension UIViewController {
    func addShadowToBar() {
        print(self.navigationController!.navigationBar.frame.height)
        print(self.navigationController!.navigationBar.frame)
        let shadowView = UIView(frame: CGRect.init(x: CGFloat(0), y: CGFloat(0), width: self.navigationController!.navigationBar.frame.width, height: self.navigationController!.navigationBar.frame.height + 20))
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.1 // your opacity
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2) // your offset
        shadowView.layer.shadowRadius =  4 //your radius
        shadowView.layer.shadowColor = UIColor.black.cgColor
        self.view.addSubview(shadowView)
        //self.navigationController!.navigationBar.sendSubview(toBack: shadowView)
        /*
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowPath = UIBezierPath(rect: self.navigationController!.navigationBar.bounds).cgPath
        self.navigationController?.navigationBar.layer.shouldRasterize = true
        self.navigationController?.navigationBar.layer.rasterizationScale = UIScreen.main.scale*/
    }
    
}



// Font Names
// ["SofiaPro-SemiBoldItalic", "SofiaPro-LightItalic", "SofiaProExtraLight-Italic", "SofiaPro-Italic", "SofiaPro-UltraLightItalic", "SofiaPro-Bold", "SofiaPro-BlackItalic", "SofiaPro-Black", "SofiaPro-SemiBold", "SofiaPro-ExtraLight", "SofiaPro-Medium", "SofiaProRegular", "SofiaPro-Light", "SofiaPro-MediumItalic", "SofiaPro-BoldItalic", "SofiaPro-UltraLight"]


