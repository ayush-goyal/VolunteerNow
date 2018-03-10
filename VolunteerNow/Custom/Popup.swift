//
//  Popup.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 3/1/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import Presentr
import UIKit

class Popup {
    private init() {}
    
    static private var presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.presentationType = .alert
        
        let animation = CoverVerticalAnimation(options: .spring(duration: 1.0, delay: 0, damping: 0.7, velocity: 0))
        let coverVerticalWithSpring = TransitionType.custom(animation)
        presenter.transitionType = coverVerticalWithSpring
        presenter.dismissTransitionType = coverVerticalWithSpring
        presenter.backgroundOpacity = 0.5
        
        return presenter
    }()
    
    static func presentError(text: String, viewController: UIViewController?, title: String = "Error", appDelegateWindow: UIWindow? = nil) {
        let alertController = Presentr.alertViewController(title: title, body: text)
        let okAction = AlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        if let window = appDelegateWindow {
            DispatchQueue.main.async {
                window.rootViewController?.customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                viewController?.customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
            }
        }
    }
}
