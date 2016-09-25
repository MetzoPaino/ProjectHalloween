//
//  StickerBrowserViewController.swift
//  StickerTest
//
//  Created by William Robinson on 21/09/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import Foundation
import UIKit
import Messages

class StickerBrowserViewController: MSStickerBrowserViewController {
    
    var stickers = [MSSticker]()
    
    func loadStickers() {
        
        createSticker(asset: "Blue", localizedDescription: "Blue")
        createSticker(asset: "Red", localizedDescription: "Red")
        createSticker(asset: "Yellow", localizedDescription: "Yellow")
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
    
    
    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
        return stickers[index]
    }
}
