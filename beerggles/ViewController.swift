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

    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var optionsView: UIView!
    
    var animating: Bool = false
    
    /// ANIMATION
    var beerggle_value: Double = 0
    var DEFAULT_SCALING: Double = 10.0
    var FADE_OUT_SCALING: Double = 2.0
    
    var delay: NSTimeInterval = 0
    var duration: NSTimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// blurView
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.bringUpOptions))
        blurView.addGestureRecognizer(tapGesture)
        
        /// Camera Capture Logic
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if (device.position == AVCaptureDevicePosition.Back) {
                captureDevice = device as? AVCaptureDevice
            }
        }
        
        /// Start video capture
        if (captureDevice != nil) {
            do {
                captureSession.addInput( try AVCaptureDeviceInput(device: captureDevice))
            } catch {
                /// todo: error handling
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.cameraView.layer.addSublayer(previewLayer)
            previewLayer?.frame = self.cameraView.bounds
            
            let previewLayerConnection: AVCaptureConnection = previewLayer.connection
            
            /// we are limiting app to Landscape Left
            previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
            
            captureSession.startRunning()
        } else {
            // todo: throw an error cannot read camera
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bringUpOptions() {
        self.animating = false
        self.blurView.layer.removeAllAnimations()
        self.view.bringSubviewToFront(optionsView)
    }

    @IBAction func setBeerggleScale(sender: BeerggleScaleButton) {
        self.view.sendSubviewToBack(optionsView)
        
        beerggle_value = sender.beerggle_scale / DEFAULT_SCALING
        
        duration = 0.85
        delay = 0
        
        self.animating = true
        fadeIn()
    }
    
    func fadeIn() {
        UIView.animateWithDuration(duration, delay: delay, options: [.CurveEaseInOut, .AllowUserInteraction], animations: {
            self.blurView.alpha = CGFloat(self.beerggle_value)
            }) { (finished) in
                if (self.animating) {
                    self.fadeOut()
                }
        }
    }
    
    func fadeOut() {
        UIView.animateWithDuration(duration, delay: delay, options: [.CurveEaseInOut, .AllowUserInteraction], animations: {
            self.blurView.alpha = CGFloat(self.beerggle_value / self.FADE_OUT_SCALING)
        }) { (finished) in
            if (self.animating) {
                self.fadeIn()
            }
        }
    }

}

