//
//  CameraController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController {
    var captureSession: AVCaptureSession?
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?
    var captureMetadataOutput: AVCaptureMetadataOutput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var metadataObjectsDelegate: AVCaptureMetadataOutputObjectsDelegate!
    
}

extension CameraController {
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
            
            let cameras = (session.devices.flatMap { $0 })
            guard !cameras.isEmpty else { throw CameraControllerError.noCamerasAvailable }
            
            self.rearCamera = cameras.first
            try self.rearCamera?.lockForConfiguration()
            self.rearCamera?.focusMode = .continuousAutoFocus
            self.rearCamera?.unlockForConfiguration()
            
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
                
            }
                
            else { throw CameraControllerError.noCamerasAvailable }
        }
        
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            self.photoOutput = AVCapturePhotoOutput()
            if #available(iOS 11.0, *) {
                self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            } else {
                self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
            }
            
            if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
            
            self.captureMetadataOutput = AVCaptureMetadataOutput()
            
            if captureSession.canAddOutput(self.captureMetadataOutput!) { captureSession.addOutput(self.captureMetadataOutput!) }
            
            self.captureMetadataOutput!.setMetadataObjectsDelegate(metadataObjectsDelegate, queue: DispatchQueue.main)
            self.captureMetadataOutput!.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        self.previewLayer?.frame = view.frame
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
    }
    
    func focusDevice(forPoint focusPoint: CGPoint) {
        guard let rearCamera = self.rearCamera else { return }
        
        do {
            try rearCamera.lockForConfiguration()
            rearCamera.focusPointOfInterest = focusPoint
            rearCamera.focusMode = .continuousAutoFocus
            rearCamera.exposurePointOfInterest = focusPoint
            rearCamera.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
            rearCamera.unlockForConfiguration()
        }
        catch {
            print("Unable to focus rear camera: \(error.localizedDescription)")
        }
    }
    
}

extension CameraController {
    enum CameraControllerError: Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
}
