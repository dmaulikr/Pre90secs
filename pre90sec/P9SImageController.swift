//
//  P9SImageController.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/17/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ImageCell"

class P9SImageController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var images = [UIImage]()
    var selectedIndex = IndexPath()
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let imageDirectory = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/inspirationalImages"
            let imageFiles = try FileManager.default.contentsOfDirectory(atPath: imageDirectory)
            for imagefile in imageFiles {
                do {
                    let thisImage = try Data.init(contentsOf: URL(fileURLWithPath:"\(imageDirectory)/\(imagefile)"))
                    images.append(UIImage(data: thisImage)!)
                    
                } catch {
                    print("\(imagefile)")
                }
            }
            
        } catch {
            
        }
        let screenWidth = self.view.bounds.width - CGFloat((4)*2)
        let cellWidth = CGFloat(screenWidth/3)
        self.flowLayout.itemSize = CGSize(width:cellWidth, height:cellWidth)
        self.collectionView?.setCollectionViewLayout(flowLayout, animated: true)
    }

    @IBAction func plusTouched(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Image", message: "", preferredStyle: .actionSheet)
        
        func launchPicker(sourceType:UIImagePickerControllerSourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alertController.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { alertAction in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                launchPicker(sourceType: .camera)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Choose Photo From Library", style: .default, handler: { alertAction in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                launchPicker(sourceType: .photoLibrary)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender.value(forKey: "view") as! UIView?
            popoverController.sourceRect = (popoverController.sourceView?.bounds)!
        }
        self.present(alertController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.images.append(pickedImage)
            self.collectionView?.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PhotoTouched" {
            let vc = segue.destination as! P9SImageViewerController
            vc.selectedPhotoIndex = self.selectedIndex
            vc.images = self.images
            
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! P9SImageCell
    
        cell.imageView.image = self.images[indexPath.item];
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.performSegue(withIdentifier: "PhotoTouched", sender: nil)
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}