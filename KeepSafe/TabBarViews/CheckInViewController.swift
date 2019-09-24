//
//  CheckInViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-07-15.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import AVFoundation

class CheckInViewController: UIViewController {
    var index: Int = 0
    weak var timer: Timer?
    let shortFlash: Double = 2
    let longFlash: Double = 4
    let pause: Double = 2
    
    var sequenceOfFlashes: [Double] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Check In"

        // Do any additional setup after loading the view.
    }
//    func setupMorseFlashesSequence(){
//        let dot: Character = "•"
//        let line: Character = "—"
//        
//        for i in translatedArray {
//            switch i {
//            case dot:
//                sequenceOfFlashes.append(shortFlash)
//                sequenceOfFlashes.append(pause)
//            case line:
//                sequenceOfFlashes.append(longFlash)
//                sequenceOfFlashes.append(pause)
//            default:
//                return
//            }
//        }
//        print(sequenceOfFlashes)
//    }
    
    @IBAction func buttonPressed(_ sender: Any) {

        
//
//    }
//    @objc func flashlight() {
//
//    }
//    func scheduleTimer(){
//        timer = Timer.scheduledTimer(timeInterval: sequenceOfFlashes[index], target: self, selector: #selector(timerTick), userInfo: nil, repeats: false)
//    }
//
//    @objc func timerTick(){
//        index += 1
//        if index == sequenceOfFlashes.count {
//            stop()
//        }
//        turnFlashlight(on: index % 2 == 0)
//        scheduleTimer()
//    }
//
//    func start(){
//        index = 0
//        turnFlashlight(on: true)
//        scheduleTimer()
//    }
//
//    func stop(){
//        timer?.invalidate()
//        turnFlashlight(on: false)
//    }
//
//    deinit{
//        timer?.invalidate()
//    }
    
}

/*
 guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
 guard device.hasTorch else { return }
 
 do {
 try device.lockForConfiguration()
 
 if (device.torchMode == AVCaptureDevice.TorchMode.on) {
 device.torchMode = AVCaptureDevice.TorchMode.off
 } else {
 do {
 try device.setTorchModeOn(level: 1.0)
 } catch {
 print(error)
 }
 }
 
 device.unlockForConfiguration()
 } catch {
 print(error)
 }
 */
}
