//
//  QRScannerController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var capturePreviewView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
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
                            if let completed = value["completed"] as? [Int], let _ = completed.index(of: self.eventId) {
                                Popup.presentError(text: "User has already checked in for this event.", viewController: self)
                                self.idScanned = false
                                return
                            } else {
                                Popup.presentError(text: "User is not signed up for this event.", viewController: self)
                                self.idScanned = false
                                return
                            }
                            
                        }
                        
                    } else {
                        self.idScanned = false
                    }
                }
                
                App.shared.dbRef.child("event-users").child(String(eventId)).observeSingleEvent(of: .value) { snapshot in
                    if let value = snapshot.value as? NSDictionary {
                        if var fcm = value["fcm"] as? [String], var uid = value["uid"] as? [String] {
                            if let index = uid.index(of: message) {
                                let userUid = uid.remove(at: index)
                                let userFcm = fcm.remove(at: index)
                                
                                if var fcmChecked = value["fcm-checked"] as? [String], var uidChecked = value["uid-checked"] as? [String] {
                                    uidChecked.append(userUid)
                                    fcmChecked.append(userFcm)
                                    
                                    App.shared.dbRef.child("event-users").child(String(self.eventId)).child("uid-checked").setValue(NSArray(array: uidChecked))
                                    App.shared.dbRef.child("event-users").child(String(self.eventId)).child("fcm-checked").setValue(NSArray(array: fcmChecked))
                                } else {
                                    App.shared.dbRef.child("event-users").child(String(self.eventId)).child("uid-checked").setValue(NSArray(array: [userUid]))
                                    App.shared.dbRef.child("event-users").child(String(self.eventId)).child("fcm-checked").setValue(NSArray(array: [userFcm]))
                                }
                                
                                App.shared.dbRef.child("event-users").child(String(self.eventId)).child("uid").setValue(NSArray(array: uid))
                                App.shared.dbRef.child("event-users").child(String(self.eventId)).child("fcm").setValue(NSArray(array: fcm))
                            }
                            
                            
                        }
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

