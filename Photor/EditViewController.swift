//
//  ViewController.swift
//  Photor
//
//  Created by MAC05 on 04/10/2017.
//  Copyright © 2017 MAC34. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var PhotoButton: UIButton!
    
    @IBOutlet var btnStartEditing: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnStartEditing.hidden = true
        
    }
    
    
    
    
    
    @IBAction func btnPhotoFromCamera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true;
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion: nil)
            
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "You don't have a camera for this device", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnPhotoFromGallery(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true;
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func removeImage(sender: AnyObject) {
        imgView.image = nil
        btnStartEditing.hidden = true
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let getImageFromLibrary = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imgView.image = getImageFromLibrary
            btnStartEditing.hidden = false
        }
            
        else {
            print("Error----")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func btnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! ViewController
        destinationViewController.passImage = imgView.image
    }
    
    
    
}

