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
                messageLabel.text = metadataObj.stringValue
                
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

