//
//  itemViewController.swift
//  Photor
//
//  Created by MAC10 on 15/10/2017.
//  Copyright © 2017 FV iMAGINATION. All rights reserved.
//

import UIKit

class itemViewController: UIViewController {
    
    
    
    var itemIndex: Int = 0
    var imageName: String = "" {
        didSet {
            if let imageView = contentimageView{
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    
    @IBOutlet weak var contentimageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentimageView.image = UIImage(named: imageName)
        
    }


}
