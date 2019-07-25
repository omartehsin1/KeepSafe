//
//  CameraViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-07-03.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import AVFoundation


class CameraViewController: UIViewController {
//    let captureSession = AVCaptureSession()
//    var previewLayer: CALayer!
//    var captureDevice: AVCaptureDevice!
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        //prepareCamera()
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSession.Preset.photo
        let backCamera =  AVCaptureDevice.default(for: AVMediaType.video)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey:  AVVideoCodecType.jpeg]
            
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity =    AVLayerVideoGravity.resizeAspect
                videoPreviewLayer!.connection?.videoOrientation =   AVCaptureVideoOrientation.portrait
                view.layer.addSublayer(videoPreviewLayer!)
                session!.startRunning()
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = view.bounds
    }

    
//    func prepareCamera() {
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//
//    let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInMicrophone], mediaType: AVMediaType.video, position: .back).devices
//        captureDevice = availableDevices.first
//        beginSession()
//
//    }
//
//    func beginSession() {
//
//        do {
//            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
//
//            captureSession.addInput(captureDeviceInput)
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        self.previewLayer = previewLayer
//        self.view.layer.addSublayer(previewLayer)
//        self.previewLayer.frame = self.view.layer.frame
//        captureSession.startRunning()
//
//        let dataOutput = AVCaptureVideoDataOutput()
//        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): NSNumber(value: kCVPixelFormatType_32BGRA)]
//        dataOutput.alwaysDiscardsLateVideoFrames = true
//
//        if captureSession.canAddOutput(dataOutput) {
//            captureSession.addOutput(dataOutput)
//        }
//        captureSession.commitConfiguration()
//
//    }


}
