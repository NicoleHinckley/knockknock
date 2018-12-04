//
//  CameraVC.swift
//  knockknock
//
//  Created by Nicole Hinckley on 11/9/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit
import LLSimpleCamera
import AVKit
import AVFoundation


class CameraVC : UIViewController {
    @IBOutlet weak var backgroundImage : UIImageView!
    
    var camera = LLSimpleCamera()
    
    override func viewDidLoad() {
        camera = LLSimpleCamera(quality: AVCaptureSession.Preset.high.rawValue, position: LLCameraPositionRear, videoEnabled: false)
        camera.attach(to: self, withFrame: self.view.frame)
        
        camera.start()
        
        NotificationCenter.default.addObserver(self, selector: #selector(takePicture(_:)), name: NotificationNames.TAKE_PICTURE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(flipCamera(_:)), name: NotificationNames.FLIP_CAMERA, object: nil)
    }
    
    
    @objc func takePicture(_ notification:Notification) {
        // Do something now
        camera.capture({ (camera, image, info, error) in
             camera?.stop()
             camera?.start()
             NotificationCenter.default.post(name: NotificationNames.DID_TAKE_PICTURE, object: image)
         
        }, exactSeenImage: true)
    }
    
    @objc func flipCamera(_ notification:Notification) {
        // Do something now
        camera.togglePosition()
    }
    
}

struct NotificationNames {
    static let TAKE_PICTURE = NSNotification.Name(rawValue: "TAKE_PICTURE")
    static let FLIP_CAMERA = NSNotification.Name(rawValue: "FLIP_CAMERA")
    static let DID_TAKE_PICTURE = NSNotification.Name(rawValue: "DID_TAKE_PICTURE")
}
