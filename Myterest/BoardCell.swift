//
//  BoardCellTableViewCell.swift
//  Myterest
//
//  Created by Mikael Teklehaimanot on 3/25/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit

class BoardCell: UITableViewCell {
    
    @IBOutlet weak var boardName: UILabel!
    @IBOutlet weak var lastUpdated: UILabel!
    @IBOutlet weak var pinsContainer: BoardPinsContainerView!
    
    @IBOutlet weak var boardImageView: PinImageView!
    
    var board: Board? {
        didSet {
            boardName.text = board?.name
            lastUpdated.text = board?.createdAt
        }
    }

    //TODO: Query for more board pins to update board cell with more images
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        boardName.text = ""
        lastUpdated.text = ""
        boardImageView.image = nil
    }

}
