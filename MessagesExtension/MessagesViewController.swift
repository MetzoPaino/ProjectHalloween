//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by William Robinson on 21/09/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController, MonsterBrowserViewControllerDelegate, MonsterMakerViewControllerDelegate {
    
    
    
    //var stickerBrowserViewController: StickerBrowserViewController!

    
    
    let dataManager = DataManager()

    
    
    
    
   // @IBOutlet weak var collectionView: UICollectionView!
    
//    override func willBecomeActive(with conversation: MSConversation) {
//        super.willBecomeActive(with: conversation)
//        
//        // Present the view controller appropriate for the conversation and presentation style.
//        presentChildViewController(for: .compact)
//    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //stickerBrowserViewController = StickerBrowserViewController(stickerSize: .regular)
        //stickerBrowserViewController.view.frame = self.view.frame
//        stickerBrowserViewController.view.frame = self.containerView.frame
//        //self.addChildViewController(stickerBrowserViewController)
//        //self.view.addSubview(stickerBrowserViewController.view)
//        
       // stickerBrowserViewController.loadStickers()
//        stickerBrowserViewController.stickerBrowserView.reloadData()
//        
//        
//        
//        
////        self.containerView.addSubview(stickerBrowserViewController.view)
//        //self.stickerBrowserViewController.view.bounds = self.containerView.bounds
//        stickerBrowserViewController.view.sizeToFit()
//       // stickerBrowserViewController.didMove(toParentViewController: self)
//        print("stickerBrowserViewController bounds = \(stickerBrowserViewController.view.bounds.size.height)")
//        
//        customStickerView.sticker = stickerBrowserViewController.stickers.first
//        customStickerView.backgroundColor = UIColor.black
        //customStickerView.sticker
        //customStickerView = MSStickerView(frame: customStickerView.frame, sticker: stickerBrowserViewController.stickers.first)
        
//        self.containerView.addSubview(stickerView)
//        
//        stickerView.bounds = self.containerView.bounds
//        
//        stickerView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
//        
//        let stickerView = MSStickerView(frame: self.containerView.frame, sticker: stickerBrowserViewController.stickers.first)
//        self.containerView.addSubview(stickerView)
//
//        stickerView.bounds = self.containerView.bounds
//
//        stickerView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    }
    
    override func viewDidLayoutSubviews() {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    private func presentChildViewController(for presentationStyle: MSMessagesAppPresentationStyle) {
        
        //let controller: UIViewController
        
        if presentationStyle == .compact {
            
            let controller = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "MonsterBrowser") as! MonsterBrowserViewController
            controller.delegate = self
            controller.stickerManager = dataManager.stickerManager
            showViewController(controller: controller)

        } else {
            
            let controller = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "MonsterMaker") as! MonsterMakerViewController
            controller.delegate = self
            showViewController(controller: controller)
        }
        
//        addChildViewController(controller)
//        
//        controller.view.frame = view.bounds
//        
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(controller.view)
//        
//        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        
//        controller.didMove(toParentViewController: self)
    }
    
    func showViewController(controller: UIViewController) {
        
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        super.willBecomeActive(with: conversation)
        presentChildViewController(for: .compact)

    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
        dataManager.saveData()
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        
        presentChildViewController(for: presentationStyle)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
    // MARK: - MonsterBrowserViewControllerDelegate
    
    func addCellSelected() {
        
        self.requestPresentationStyle(.expanded)
    }

    // MARK: - MonsterMakerViewControllerDelegate

    func createdStickerAtFileURL(fileURL: URL) {
        
        dataManager.stickerManager.customStickerFileURLS.append(fileURL)
        dataManager.stickerManager.loadCustomStickers()
        self.requestPresentationStyle(.compact)

    }
}