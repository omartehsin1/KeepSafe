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


class CameraViewController: UIViewController {
    
    var pickerController = UIImagePickerController()
    let videoFileName = "/video.mp4"
    
    @IBOutlet var cameraView: UIView!
    let cameraManager = CameraManager()
    var myVideoURL : URL!
    var recordButton = UIBarButtonItem()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //startCamera()
        //takeVideo()
        createGalleryButton()
        createRecordButton()
        
        cameraManager.addPreviewLayerToView(cameraView)
        //recordVideo()
        
        
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
    
    func createRecordButton() {
        let recordButton = UIButton(frame: CGRect(x: 150, y: 490, width: 107, height: 100))
        //let SOSButton = UIButton()

        recordButton.layer.cornerRadius = 50
        recordButton.layer.masksToBounds = true

        recordButton.backgroundColor = .orange
        recordButton.setTitle("Record", for: .normal)
        recordButton.addTarget(self, action: #selector(recordVideo), for: .touchUpInside)

        //cameraView.addSubview(recordButton)
        cameraView.bringSubviewToFront(recordButton)
//        recordButton = UIBarButtonItem(title: "Record", style: .plain, target: self, action: #selector(recordVideo))
//        self.navigationItem.rightBarButtonItem = recordButton
        
    }

    @objc func recordVideo() {
        print("Record button has been touched!")
        switch cameraManager.cameraOutputMode {
        case .videoOnly, .videoWithMic:
            
            recordButton.tintColor = .red
            cameraManager.startRecordingVideo()
        default:
            cameraManager.stopVideoRecording { (videoURL, error) in
//                if error != nil {
//                    self.cameraManager.showErrorBlock("Error occured", "Cannot save video")
//                }
                guard let videoURL = videoURL else {
                    return
                }
                do {
                    try FileManager.default.copyItem(at: videoURL, to: self.myVideoURL)
                }
                catch {
                    print(error)
                    
                }
            }
        }
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
