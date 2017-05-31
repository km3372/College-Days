//
//  MemoriesViewController.swift
//  CollegeDays
//
//  Created by kenneth moody on 5/29/17.
//  Copyright © 2017 iMoody Studios. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Speech

class MemoriesViewController: UICollectionViewController {
    
    var memories = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func checkPermissions() {
        //check status for all 3 permissions
        
        let photosAuthorized = PHPhotoLibrary.authorizationStatus() == .authorized
        let recordingAuthorized = AVAudioSession.sharedInstance().recordPermission() == .granted
        let transcribeAuthorized = SFSpeechRecognizer.authorizationStatus() == .authorized
        
        //make a single boolean out of all three
        
         let authorized = photosAuthorized && recordingAuthorized && transcribeAuthorized
        
        //if were missing one, show the first run screen
        
        if authorized == false {
            
            if let vc = storyboard?.instantiateViewController(withIdentifier: "FirstRun") {
                
                navigationController?.present(vc, animated: true)
            }
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkPermissions()
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docmentsDirectory = paths[0]
        
        return docmentsDirectory
    }
    
    func loadMemories() {
        
        memories.removeAll()
        
        //attempt to load all the memories in our documents directory
        
        guard let files = try?
            FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil, options: []) else {return}
        
        //loop over every file
        
        for file in files {
            let filename = file.lastPathComponent
            
            //check it ends with ".thumb" so we dont count each memory more than once
            if filename.hasSuffix(".thumb") {
                
                //get the root name of the memory(i.e., without its patch extension)
                let noExtension = filename.replacingOccurrences(of: ".thumb", with: "")
                
                //create a full path from the memory
                
                let memoryPath = getDocumentsDirectory().appendingPathComponent(noExtension)
                
                //add it to our array
                memories.append(memoryPath)
            }
        }
        
        //reload our list of memories
        collectionView?.reloadSections(IndexSet(integer: 1))
    }
    
    
}
