//
//  BoardPinsContainerView.swift
//  Myterest
//
//  Created by Mikael Teklehaimanot on 3/25/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit

class BoardPinsContainerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //@IBOutlet weak var imageView1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.backgroundColor = UIColor.lightGray
    }
    
    //TODO: Refactor======= 
    //1. Get all parsed pin images (max 8)
    //2. Update ImageViewOutlets using viewWithTag (1 - 8)

}
