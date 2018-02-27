//
//  QRScannerController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit
import AVFoundation
import Presentr

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var capturePreviewView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.presentationType = .alert
        
        let animation = CoverVerticalAnimation(options: .spring(duration: 1.0, delay: 0, damping: 0.7, velocity: 0))
        let coverVerticalWithSpring = TransitionType.custom(animation)
        presenter.transitionType = coverVerticalWithSpring
        presenter.dismissTransitionType = coverVerticalWithSpring
        presenter.backgroundOpacity = 0.5
        
        return presenter
    }()
    
    func presentError(text: String) {
        let alertController = Presentr.alertViewController(title: "Error", body: text)
        let okAction = AlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    var eventId: Int!
    private var idScanned = false
    
    var cameraController = CameraController()
    
    // Initialize QR Code Frame to highlight the QR code
    var qrCodeFrameView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 2
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraController.metadataObjectsDelegate = self
        
        configureCameraController()
        
        navigationItem.title = "Scanner"
        addShadowToBar()
        addShadowToTabBar()
        
        view.addSubview(qrCodeFrameView)
        view.bringSubview(toFront: qrCodeFrameView)
    }
    
    func configureCameraController() {
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.cameraController.displayPreview(on: self.capturePreviewView)
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = cameraController.previewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                guard let message = metadataObj.stringValue else { return }
                messageLabel.text = message
                if idScanned == true {
                    return
                } else {
                    idScanned = true
                }
                App.shared.dbRef.child("users").child(message).observeSingleEvent(of: .value) { snapshot in
                    if let value = snapshot.value as? NSDictionary {
                        print(value["upcoming"] as? [Int])
                        if var upcoming = value["upcoming"] as? [Int], let index = upcoming.index(of: self.eventId) {
                            upcoming.remove(at: index)
                            print(upcoming)
                            App.shared.dbRef.child("users/\(message)/upcoming").setValue(upcoming)
                            if var completed = value["completed"] as? [Int] {
                                completed.append(self.eventId)
                                App.shared.dbRef.child("users/\(message)/completed").setValue(NSArray(array: completed))
                            } else {
                                App.shared.dbRef.child("users/\(message)/completed").setValue(NSArray(array: [self.eventId]))
                            }
                            self.performSegue(withIdentifier: "checkInConfirmationSegue", sender: nil)
                        } else {
                            self.presentError(text: "User is not signed up for this event.")
                            self.idScanned = false
                            return
                        }
                        
                    } else {
                        self.idScanned = false
                    }
                }
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let screenSize = capturePreviewView.bounds.size
        if let touchPoint = touches.first {
            let x = touchPoint.location(in: capturePreviewView).y / screenSize.height
            let y = 1.0 - touchPoint.location(in: capturePreviewView).x / screenSize.width
            let focusPoint = CGPoint(x: x, y: y)
            
            cameraController.focusDevice(forPoint: focusPoint)
        }
    }
    
    
}

