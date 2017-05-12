//
//  PinCell.swift
//  Myterest
//
//  Created by Mikael Teklehaimanot on 3/27/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import PinterestSDK

class PinCell: UICollectionViewCell {
    
    @IBOutlet weak var pinImageView: PinImageView!
    @IBOutlet weak var pinDescriptionLabel: UILabel!
    @IBOutlet weak var pinImageViewHeightConstraint: NSLayoutConstraint!
    
    var pin: PDKPin? {
        didSet {
            if let pin = pin {
                pinImageView.setImageWith(URLRequest(url: pin.largestImage().url), placeholderImage: nil, success: {
                    request, response, image in
                    self.pinImageView.image = image
                }, failure: nil)
                pinDescriptionLabel.text = pin.descriptionText
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pinImageView.image = nil
        pinDescriptionLabel.text = ""
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let attributes = layoutAttributes as! PinLayoutAttributes
        pinImageViewHeightConstraint.constant = attributes.imageHeight
    }
    
}
