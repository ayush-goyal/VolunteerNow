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
        contentMode = mode
        
        guard let url = NSURL(string: link) else { return }
        
        func addImage(image: UIImage) {
            self.image = image
            self.superview?.sendSubview(toBack: self) // Prevents image from covering text
        }
        
        // Check for cached image first
        if let cachedImage = eventImageCache.object(forKey: url) as? UIImage {
            addImage(image: cachedImage)
            return
        }
        
        // Otherwise request image
        let urlRequest = URLRequest(url: url as URL)

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                eventImageCache.setObject(image, forKey: url)
                addImage(image: image)
                return
            }
        }
        task.resume()
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

extension UIViewController {
    func addShadowToBar() {
        let shadowView = UIView(frame: CGRect.init(x: CGFloat(0), y: CGFloat(0), width: self.navigationController!.navigationBar.frame.width, height: self.navigationController!.navigationBar.frame.height + 20))
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius =  4
        shadowView.layer.shadowColor = UIColor.black.cgColor
        self.view.addSubview(shadowView)
    }
    
    func addShadowToTabBar() {
        let shadowView = UIView(frame: CGRect.init(x: CGFloat(0), y: CGFloat(UIScreen.main.bounds.height-self.tabBarController!.tabBar.frame.height), width: self.tabBarController!.tabBar.frame.width, height: self.tabBarController!.tabBar.frame.height))
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -2)
        shadowView.layer.shadowRadius =  4
        shadowView.layer.shadowColor = UIColor.black.cgColor
        self.view.addSubview(shadowView)
    }
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func changeBackNavigationButton() {
        let backImage = UIImage(named: "backArrow")!
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
}

// Extension for SkyFloatingLabelTextField
extension UITextField {
    /// Moves the caret to the correct position by removing the trailing whitespace
    func fixCaretPosition() {
        // Moving the caret to the correct position by removing the trailing whitespace
        // http://stackoverflow.com/questions/14220187/uitextfield-has-trailing-whitespace-after-securetextentry-toggle
        
        let beginning = beginningOfDocument
        selectedTextRange = textRange(from: beginning, to: beginning)
        let end = endOfDocument
        selectedTextRange = textRange(from: end, to: end)
    }
}

extension UILabel {
    func setTextandHeight(text: String, lineSpacing: CGFloat, font: UIFont, alignment: NSTextAlignment, leftRightMargin: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.font: font]
        
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        
        let width = UIScreen.main.bounds.width-(leftRightMargin * 2)
        let size = CGSize(width: width, height: 400)
        
        let frame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        self.attributedText = attributedText
        self.heightAnchor.constraint(equalToConstant: frame.height+5)
        
    }
}

// MARK: - Custom Project Colors & Fonts
extension UIColor {
    struct Custom {
        static let darkGray = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
        static let lightGray = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1)
        static let backgroundGray = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        static let purple = UIColor(red: 96/255, green: 77/255, blue: 198/255, alpha: 1)
    }
}

extension UIFont {
    struct Custom {
        static let mainTitle = UIFont(name: "SofiaPro-Bold", size: 21)!
        static let subTitle = UIFont(name: "SofiaPro-SemiBold", size: 19)!
        static let heading = UIFont(name: "SofiaPro-Bold", size: 17)!
        static let text = UIFont(name: "SofiaPro-Medium", size: 17)!
    }
}



// Font Names
// ["SofiaPro-SemiBoldItalic", "SofiaPro-LightItalic", "SofiaProExtraLight-Italic", "SofiaPro-Italic", "SofiaPro-UltraLightItalic", "SofiaPro-Bold", "SofiaPro-BlackItalic", "SofiaPro-Black", "SofiaPro-SemiBold", "SofiaPro-ExtraLight", "SofiaPro-Medium", "SofiaProRegular", "SofiaPro-Light", "SofiaPro-MediumItalic", "SofiaPro-BoldItalic", "SofiaPro-UltraLight"]


