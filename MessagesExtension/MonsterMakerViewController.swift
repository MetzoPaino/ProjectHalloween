//
//  MonsterMakerViewController.swift
//  StickerTest
//
//  Created by William Robinson on 24/09/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import UIKit
import QuartzCore

protocol MonsterMakerViewControllerDelegate: class {
    func createdStickerAtFileURL(fileURL: URL)
}

class MonsterMakerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var panGesture = UIPanGestureRecognizer()
    var longGesture = UILongPressGestureRecognizer()

    @IBOutlet weak var canvasImageView: UIImageView!
    
    
    
    
    weak var delegate: MonsterMakerViewControllerDelegate?

    
    var images = [UIImage(named:"Boo"), UIImage(named:"Eyeball"), UIImage(named:"HappyHalloween"), UIImage(named:"KeepingItSpooky"), UIImage(named:"Mask")]
    
    var movingImage = UIImageView()
    var moving = false
    
    var createdImage = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasImageView.isOpaque = false
        canvasImageView.layer.isOpaque = false
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(MonsterMakerViewController.handlePan(_:)))
//        panGesture.delegate = self
//        collectionView.addGestureRecognizer(panGesture)

        
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(MonsterMakerViewController.handleLongPress(_:)))
        longGesture.delegate = self
        collectionView.addGestureRecognizer(longGesture)
        
        canvasImageView.isUserInteractionEnabled = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if moving == false {
            return true
            
        } else {
            return false
        }
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        
//        if moving == false {
//            return true
//
//        } else {
//            return false
//        }
//    }
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        cell.backgroundColor = .green
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = images[indexPath.row]
        cell.tag = indexPath.row * 10
        
        return cell
    }
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        
        let windowLocationPoint = sender.location(in: nil)
        
        if sender.state == .changed {
            
            let image = sender.view!
            image.center = windowLocationPoint
            
        }
        
    }
    
    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
        let locationPoint = sender.location(in: collectionView)
        let windowLocationPoint = sender.location(in: nil)
        let canvasLocationPoint = sender.location(in: canvasImageView)

        if sender.state == .began {
            
            guard let selectedIndexPath = collectionView.indexPathForItem(at: locationPoint),
                let cell = collectionView.cellForItem(at: selectedIndexPath) else {
                    moving = false
                    collectionView.isUserInteractionEnabled = true
                    
                    return
            }
            print("cell tag = \(cell.tag)")
            moving = true
            collectionView.isUserInteractionEnabled = false
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            movingImage = UIImageView(image: imageView.image)
            movingImage.center = windowLocationPoint
            movingImage.alpha = 1.0
            movingImage.frame = cell.frame
            view.addSubview(movingImage)
            
        } else if sender.state == .changed {
            
            movingImage.center = windowLocationPoint
            
        } else if sender.state == .ended {
            
            collectionView.isUserInteractionEnabled = true
            
            let image = movingImage
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(MonsterMakerViewController.handlePan(_:)))
            image.addGestureRecognizer(panGesture)
            //panGesture.delegate = self
            //image.backgroundColor = .purple
            image.isUserInteractionEnabled = true
            
            if canvasImageView.point(inside: windowLocationPoint, with: nil)  {
                
                canvasImageView.addSubview(image)
                image.center = canvasLocationPoint
                createdImage.append(image)
                
            } else {
                
                movingImage.alpha = 0.0
            }
            
            movingImage = UIImageView()
            moving = false
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        createImageFrom(view: canvasImageView)
    }
    
    func createImageFrom(view: UIView) {
        
        view.backgroundColor = .clear
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        view.backgroundColor = .cyan
        print("He")
        resizeImage(image: image!)
    }
    
    func resizeImage(image: UIImage) {
        
        let stickerSize = CGRect(x: 0, y: 0, width: 300, height: 300)
        UIGraphicsBeginImageContextWithOptions(stickerSize.size, false, 1.0)
        image.draw(in: stickerSize)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("He")
        saveImage(image: resizedImage!)
    }
    
    func saveImage(image: UIImage) {
        
//        let filename = "test.jpg"
//        let subfolder = "SubDirectory"
//        
//        do {
//            let fileManager = FileManager.default
//            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            let folderURL = documentsURL.appendingPathComponent(subfolder)
//            
//            do {
//                
//                try folderURL.checkPromisedItemIsReachable()
//                
//                
//            }
//            
//            
//            
//            
//            
//            
//            if !folderURL.   checkPromisedItemIsReachableAndReturnError(nil) {
//                try fileManager.createDirectoryAtURL(folderURL, withIntermediateDirectories: true, attributes: nil)
//            }
//            let fileURL = folderURL.URLByAppendingPathComponent(filename)
//            
//            try imageData.writeToURL(fileURL, options: .AtomicWrite)
//        } catch {
//            print(error)
//        }
        
        
        do {
            
            let fileManager = FileManager.default
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print(documentsURL)
            
            let folderURL = documentsURL.appendingPathComponent("Sticker")
            
            do {
                let reachable = try folderURL.checkPromisedItemIsReachable()
                print("reachable!")
                
                let fileURL = folderURL.appendingPathComponent("MyImageName1.png")
                
                let imageData: Data = UIImagePNGRepresentation(image)!
                
                try imageData.write(to: fileURL)
                
            } catch {
                
                print("error = \(error)")
                do {
                   try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                    print("must have made")
                    
                    let fileURL = folderURL.appendingPathComponent("MyImageName2.png")
                    
                    let imageData: Data = UIImagePNGRepresentation(image)!
                    
                    try imageData.write(to: fileURL)
                    
                } catch {
                    
                    print(error)
                }
            }
            
        } catch {
            
            print(error)
        }

        // Below works, i don't know if above does
            
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

        
        let fileUrl = Foundation.URL(string: "file://\(paths[0])/\(UUID().uuidString).png")
        
        
        do {
            let imageData: Data = UIImagePNGRepresentation(image)!
            
           // try imageData.write(to: fileUrl!)
            
            
            try UIImagePNGRepresentation(image)?.write(to: fileUrl!)
            
            print("wrote to \(fileUrl!)")
            
            self.delegate?.createdStickerAtFileURL(fileURL: fileUrl!)

        } catch {
            
            print("unable to write to \(fileUrl!)")
            print(error)
        }
        
        
        
        
    //    UIImagePNGRepresentation(image)?.write(to: filePath) writeToFile(filePath, atomically: true)
        
        
        
        
        
        
        
        
//        let filePath = "\(paths[0])/MyImageName.png"
//
//        UIImagePNGRepresentation(image)?.write(to: filePath) writeToFile(filePath, atomically: true)
    }
}

extension MonsterMakerViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
