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
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createGalleryButton()
        createDoneButton()
        //print(isRecording)
        //createRecordButton()
        cameraManager.addPreviewLayerToView(cameraView)
        recordingInSession()
        
 
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
    
    @objc func doneItemFunc() {
        dismiss(animated: true, completion: nil)
    }



    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("error saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
            })
        }
    }
    func recordingInSession() {
        isRecording = !isRecording

        if isRecording {
            if(cameraManager.cameraOutputMode == .stillImage) {
                print("Camera output is stillImage, switching to videWithMic")
                print(isRecording)
                cameraManager.cameraOutputMode = CameraOutputMode.videoWithMic
                print(cameraManager.cameraOutputMode)
            }
            cameraManager.startRecordingVideo()
        }
        else {
            stopButton.addTarget(self, action: #selector(stopPressed), for: .touchUpInside)
        }
        
        
    }
    
    @objc func stopPressed() {
        print("stop pressed")
        cameraManager.stopVideoRecording { (videoURL, recordError) in
            print("it is not recording")
            print("videourl: \(videoURL)")
            print("recordError: \(recordError)")
            if (self.cameraManager.cameraOutputMode == .videoWithMic) {
                self.cameraManager.cameraOutputMode = CameraOutputMode.stillImage
            }
        }
    }
    

    
    @IBAction func recordButtonPressed(_ sender: Any) {
//        isRecording = !isRecording
//        if isRecording {
//            if(cameraManager.cameraOutputMode == .stillImage) {
//                cameraManager.cameraOutputMode = CameraOutputMode.videoWithMic
//                print(cameraManager.cameraOutputMode)
//            }
//            cameraManager.startRecordingVideo()
//        }
//
//        else {
//
//            cameraManager.stopVideoRecording { (videoURL, recordError) in
//                print("it is not recording")
//                print(self.isRecording)
//                guard let videoURL = videoURL else {
//                    print("videoURL not working")
//                    return
//                }
//                print("videourl: \(videoURL)")
//                if (self.cameraManager.cameraOutputMode == .videoWithMic) {
//                    self.cameraManager.cameraOutputMode = CameraOutputMode.stillImage
//                    print(self.cameraManager.cameraOutputMode)
//                }
//            }
//
//        }

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
