//
//  CameraViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-07-03.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import CameraManager
import Photos


class CameraViewController: UIViewController {
    
    var pickerController = UIImagePickerController()
    let videoFileName = "/video.mp4"
    
    @IBOutlet var cameraView: UIView!
    let theButton = UIButton()
    let cameraManager = CameraManager()
    var myVideoURL : URL?
    @IBOutlet weak var recordButton: KSRecordButton!
    var isRecording = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createGalleryButton()
        createDoneButton()
        //createRecordButton()
        cameraManager.addPreviewLayerToView(cameraView)
        
 
    }
    func createDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneItemFunc))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    func createGalleryButton() {
    let galleryButton = UIBarButtonItem(title: "Gallery", style: .plain, target: self, action: #selector(openGallery))
    self.navigationItem.rightBarButtonItem = galleryButton
    }
    
    @objc func openGallery() {
        pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        pickerController.mediaTypes = [kUTTypeMovie as String]
        pickerController.delegate = self
        
        present(pickerController, animated: true, completion: nil)
        
    }
    
//    func createRecordButton() {
//        var recordButton = UIButton(frame: CGRect(x: 239, y: 650, width: 107, height: 100))
//
//        recordButton.layer.cornerRadius = 50
//        recordButton.layer.masksToBounds = true
//
//        recordButton.backgroundColor = .orange
//        recordButton.setTitle("Record", for: .normal)
//        recordButton.addTarget(self, action: #selector(recordVideo), for: .touchUpInside)
//
//    }

//    @objc func recordVideo() {
//        print("Record button has been touched!")
//        switch cameraManager.cameraOutputMode {
//        case .videoOnly, .videoWithMic:
//
//            recordButton.tintColor = .red
//            cameraManager.startRecordingVideo()
//        default:
//            cameraManager.stopVideoRecording { (videoURL, error) in
////                if error != nil {
////                    self.cameraManager.showErrorBlock("Error occured", "Cannot save video")
////                }
//                guard let videoURL = videoURL else {
//                    return
//                }
//                do {
//                    try FileManager.default.copyItem(at: videoURL, to: self.myVideoURL)
//                }
//                catch {
//                    print(error)
//
//                }
//            }
//        }
//    }
    @objc func doneItemFunc() {
        //completion save to cloud
        dismiss(animated: true, completion: nil)
    }

    
    
    func takeVideo() {
        // 1 Check if project runs on a device with camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            // 2 Present UIImagePickerController to take video
            pickerController.sourceType = .camera
            pickerController.mediaTypes = [kUTTypeMovie as String]
            pickerController.delegate = self
            
            present(pickerController, animated: true, completion: nil)
        }
        else {
            print("Camera is not available")
        }
    }

    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("error saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
            })
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        
        
        isRecording = !isRecording
        
        if isRecording {
            if(cameraManager.cameraOutputMode == .stillImage) {
                print("Camera output is stillImage, switching to videWithMic")
                cameraManager.cameraOutputMode = CameraOutputMode.videoWithMic
            }
            cameraManager.startRecordingVideo()
            print(cameraManager.cameraOutputMode)
        }
        
        else {
            
            cameraManager.stopVideoRecording { (videoURL, recordError) in
                print("it is not recording")
                print(self.isRecording)
                guard let videoURL = videoURL else {
                    print("videoURL not working")
                    return
                }
                print("videourl: \(videoURL)")
                if (self.cameraManager.cameraOutputMode == .videoWithMic) {
                    self.cameraManager.cameraOutputMode = CameraOutputMode.stillImage
                }
            }

        }
        
    }
    

    
}
extension CameraViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 1
        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            // Save video to the main photo album
            let selectorToCall = #selector(self.videoSaved(_:didFinishSavingWithError:context:))
            
            // 2
            UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)
            // Save the video to the app directory
            let videoData = try? Data(contentsOf: selectedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(videoFileName)
            try! videoData?.write(to: dataPath, options: [])
        }
        // 3
        picker.dismiss(animated: true)
    }

    
}

extension CameraViewController: UINavigationControllerDelegate {
    
}
