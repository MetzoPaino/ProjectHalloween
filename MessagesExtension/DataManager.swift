//
//  DataManager.swift
//  StickerTest
//
//  Created by William Robinson on 25/09/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import Foundation

class DataManager {
    
    let stickerManager: StickerManager
    
    required init() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        let path = paths[0] + "/ProjectHalloween.plist"
        
        if FileManager.default.fileExists(atPath: path) {
            
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                
                if let decodedStickerManager = unarchiver.decodeObject(forKey: "StickerManager") as? StickerManager {
                    
                    stickerManager = decodedStickerManager
                    
                } else {
                    
                    stickerManager = StickerManager()
                }
                
                unarchiver.finishDecoding()
                
            } else {
                
                // I don't know how i'd end up here, so should figure that out
                stickerManager = StickerManager()
            }
            
        } else {
            
            // Probably a first launch
            stickerManager = StickerManager()
        }
        
        stickerManager.loadStickers()
        stickerManager.loadCustomStickers()
    }
    
    func dataFilePath() -> String {
        return documentsDirectory() + "/ProjectHalloween.plist"
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    func saveData() {
        
        print("Saving Data")
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(stickerManager, forKey: "StickerManager")
        
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
}

