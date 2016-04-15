//
//  ViewController.swift
//  beerggles
//
//  Created by Jerry Tsai on 2016-04-10.
//
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var optionsView: UIView!
    
    /// BEERGGLE SCALE BUTTONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Camera View Logic
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.bringUpOptions))
        cameraView.addGestureRecognizer(tapGesture)
        
        /// Options View Logic
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.optionsView.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.optionsView.addSubview(blurEffectView)
        self.optionsView.sendSubviewToBack(blurEffectView)
        
        /// Camera Capture Logic
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if (device.position == AVCaptureDevicePosition.Back) {
                captureDevice = device as? AVCaptureDevice
            }
        }
        
        if (captureDevice != nil) {
            beginSession()
        } else {
            // todo: throw an error cannot read camera
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginSession() {
        do {
            captureSession.addInput( try AVCaptureDeviceInput(device: captureDevice))
        } catch {
            /// todo: error handling
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.cameraView.bounds
        
        let previewLayerConnection: AVCaptureConnection = previewLayer.connection
        
        let currentDevice: UIDevice = UIDevice.currentDevice()
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        /// we are limiting app to Landscape Left and Landscape Right
        if (previewLayerConnection.supportsVideoOrientation) {
            switch(orientation) {
            case .LandscapeRight:
                previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.LandscapeRight
                break
             default:
                previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
                break
            }
        }
        
        self.view.bringSubviewToFront(optionsView)
        
        captureSession.startRunning()
    }
    
    func bringUpOptions() {
        self.view.bringSubviewToFront(optionsView)
    }

    @IBAction func setBeerggleScale(sender: BeerggleScaleButton) {
        self.view.sendSubviewToBack(optionsView)
    }


}

