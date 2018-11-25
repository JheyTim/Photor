//
//  ViewController.swift
//  Filters
//
//  Created by FV iMAGINATION on 30/08/16.
//  Copyright © 2016 FV iMAGINATION. All rights reserved.
//

import UIKit
import CoreImage
import AssetsLibrary

/* GLOBAL VARIABLES */
var CIFilterNames = [
    "CIGaussianBlur",
    "CIHueAdjust",
    "CIPhotoEffectChrome",
    "CIPhotoEffectFade",
    "CIPhotoEffectInstant",
    "CIPhotoEffectNoir",
    "CIPhotoEffectProcess",
    "CIPhotoEffectTonal",
    "CIPhotoEffectTransfer"
    
]



class ViewController: UIViewController{
    
    /* Views */
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var imageToFilter: UIImageView!
    
    @IBOutlet weak var filtersScrollView: UIScrollView!
    var passImage: UIImage!
    
    var library:ALAssetsLibrary = ALAssetsLibrary()

    

   
    
    
override func prefersStatusBarHidden() -> Bool {
    return true
}

override func viewDidLoad() {
        super.viewDidLoad()
    
        originalImage.image = passImage
        filtersScrollView.hidden = true
    
    
    
    
        
        // Variables for setting the Font Buttons
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 5
        
        // Items Counter
        var itemCount = 0
        
        // Loop for creating buttons ------------------------------------------------------------
        for i in 0..<CIFilterNames.count {
            itemCount = i
            
            // Button properties
            let filterButton = UIButton(type: .Custom)
            filterButton.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
            filterButton.tag = itemCount
            filterButton.showsTouchWhenHighlighted = true
            filterButton.addTarget(self, action: #selector(ViewController.filterButtonTapped(_:)), forControlEvents: .TouchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            
            // Create filters for each button
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: originalImage.image!)
            let filter = CIFilter(name: "\(CIFilterNames[i])" )
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.valueForKey(kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
            let imageForButton = UIImage(CGImage: filteredImageRef);
            
            // Assign filtered image to the button
            filterButton.setBackgroundImage(imageForButton, forState: .Normal)
            
            
            // Add Buttons in the Scroll View
            xCoord +=  buttonWidth + gapBetweenButtons
            filtersScrollView.addSubview(filterButton)
        } // END LOOP ------------------------------------------------------------------------
        
        
        // Resize Scroll View
        filtersScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(itemCount+2), yCoord)
        
}
    

// FILTER BUTTON ACTION
func filterButtonTapped(sender: UIButton) {
    let button = sender as UIButton
        
    imageToFilter.image = button.backgroundImageForState(UIControlState.Normal)

}
    
    
    
    @IBAction func showFilter(sender: AnyObject) {
        filtersScrollView.hidden = false
    }
    
    //rotate right
    @IBAction func btnBrightness(sender: AnyObject) {
        
        originalImage.image = originalImage.image?.imageRotatedByDegrees(-90, flip: false)
        imageToFilter.image = imageToFilter.image?.imageRotatedByDegrees(-90, flip: false)

        
        
    }
    
    
    @IBAction func btnRotate(sender: AnyObject) {
        originalImage.image = originalImage.image?.imageRotatedByDegrees(90, flip: false)
        imageToFilter.image = imageToFilter.image?.imageRotatedByDegrees(90, flip: false)
        
        
    }
    
    
    
    
    
    
// SAVE PICTURE BUTTON
@IBAction func savePicButton(sender: AnyObject) {
        // Save the image into camera roll
    
    
    let assetsLibrary = ALAssetsLibrary()
    
    assetsLibrary.addAssetsGroupAlbumWithName("Photor", resultBlock: { assetsGroup in
        print(assetsGroup == nil ? "Already created" : "Success")
        }, failureBlock: { error in
            print(error)
    })
    
    //UIImageWriteToSavedPhotosAlbum(imageToFilter.image!, nil, nil, nil)
    
    //condition
    if imageToFilter.image == nil {
    let image:UIImage = originalImage.image!
    library.writeImageToSavedPhotosAlbum(image.CGImage, orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!, completionBlock: saveDone)
  
    
    
        let alert = UIAlertView(title: "Filters",
                        message: "Your image has been saved to Photo Library",
                        delegate: nil,
                        cancelButtonTitle: "OK")
        alert.show()
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    else{
        let image:UIImage = imageToFilter.image!
        library.writeImageToSavedPhotosAlbum(image.CGImage, orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!, completionBlock: saveDone)
        
        
        
        let alert = UIAlertView(title: "Filters",
                                message: "Your image has been saved to Photo Library",
                                delegate: nil,
                                cancelButtonTitle: "OK")
        alert.show()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
}
    
    
    @IBAction func btnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func saveDone(assetURL:NSURL!, error:NSError!){
        print("saveDone")
        library.assetForURL(assetURL, resultBlock: self.saveToAlbum, failureBlock: nil)
    }
    
    
    func saveToAlbum(asset:ALAsset!){
        library.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: {
            group, stop in
            stop.memory = false
            if (group != nil) {
                let str = group.valueForProperty(ALAssetsGroupPropertyName) as! String
                
                if (str == "Photor"){
                    group!.addAsset(asset!)
                    let assetRep:ALAssetRepresentation = asset.defaultRepresentation()
                    let iref = assetRep.fullResolutionImage().takeUnretainedValue()
                    let image:UIImage = UIImage(CGImage: iref)
                    
                }
            }
        },
                                         failureBlock: { error in print("NOOOOOO")
        })
    }
    
    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

