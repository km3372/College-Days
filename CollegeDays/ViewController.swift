//
//  ViewController.swift
//  CollegeDays
//
//  Created by kenneth moody on 5/29/17.
//  Copyright © 2017 iMoody Studios. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Speech



class ViewController: UIViewController {

    @IBOutlet weak var helpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func requestPhotoPermissions() {
        PHPhotoLibrary.requestAuthorization { [unowned self] authStatus in
            
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.requestRecordPermission()
                } else {
                    self.helpLabel.text = "Photos permission was declined; please enable it in settings then tap Continue again"
                }
            }
        }
        
    }
    
    
    func requestRecordPermission()  {
        AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
            
            DispatchQueue.main.async {
                if allowed {
                    self.requestTranscribePermissions()
                } else {
                    self.helpLabel.text = "Recording permission was declined; please enable it in settings then tap Continue again"
                }
            }
            
        }
    }
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.authorizationComplete()
                
                } else {
                    self.helpLabel.text = "Transcription permission was declined; please enable it in settings then tap Continue again"
                }
            }
            
        }
    }
    
    func authorizationComplete() {
        
        dismiss(animated: true)
    }
    
    
    @IBAction func requestedPermissions(_ sender: UIButton) {
        
        requestPhotoPermissions()
    }

}

