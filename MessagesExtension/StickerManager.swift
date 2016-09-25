//
//  StickerManager.swift
//  StickerTest
//
//  Created by William Robinson on 25/09/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import Foundation
import Messages

class StickerManager: NSObject, NSCoding {
    
    fileprivate let customStickerFileURLSKey = "customStickerFileURLS"

    var stickers = [MSSticker]()
    var customStickers = [MSSticker]()
    var customStickerFileURLS = [URL]()

    override init() {
        super.init()
        //loadStickers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let decodedcustomStickerFileURLS = aDecoder.decodeObject(forKey: customStickerFileURLSKey) as? [URL] {
            
            customStickerFileURLS = decodedcustomStickerFileURLS
        }
        
       // loadStickers()
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(customStickerFileURLS, forKey: customStickerFileURLSKey)
    }
    
    func loadStickers() {
        
        stickers.removeAll()
        
        createSticker(asset: "Vamp0", localizedDescription: "Vampire")
        createSticker(asset: "Wolf0", localizedDescription: "Wolf")
        createSticker(asset: "Medusa0", localizedDescription: "Medusa")
        createSticker(asset: "SkullKid0", localizedDescription: "Skull")
        createSticker(asset: "Swamp0", localizedDescription: "Swamp")
        
        createSticker(asset: "Vamp1", localizedDescription: "Vampire")
        createSticker(asset: "Wolf1", localizedDescription: "Wolf")
        createSticker(asset: "Medusa1", localizedDescription: "Medusa")
        createSticker(asset: "SkullKid1", localizedDescription: "Skull")
        createSticker(asset: "Swamp1", localizedDescription: "Swamp")
        
        createSticker(asset: "Wolf2", localizedDescription: "Wolf")
        createSticker(asset: "Medusa2", localizedDescription: "Medusa")
        createSticker(asset: "SkullKid2", localizedDescription: "Skull")
        createSticker(asset: "Swamp2", localizedDescription: "Swamp")
        
        createSticker(asset: "SkullKid3", localizedDescription: "Skull")

    }
    
    func loadCustomStickers() {
        
        customStickers.removeAll()

        for url in customStickerFileURLS {
            
            createCustomSticker(fileURL: url)
        }
    }
    
    func createSticker(asset: String, localizedDescription: String) {
        
        guard let stickerPath = Bundle.main.path(forResource: asset, ofType:"png") else {
            
            print("Couldn't create the sticker path for", asset)
            return
        }
        let stickerURL = URL(fileURLWithPath: stickerPath)
        
        let sticker: MSSticker
        
        do {
            
            try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: localizedDescription)
            stickers.append(sticker)
            
        } catch {
            
            print(error)
            return
        }
    }
    
    func createCustomSticker(fileURL: URL) {
        
        let sticker: MSSticker
        
        do {
            
            try sticker = MSSticker(contentsOfFileURL: fileURL, localizedDescription: "Custom")
            customStickers.append(sticker)
            
        } catch {
            
            print(error)
            return
        }
    }
}
