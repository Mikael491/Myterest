//
//  Board.swift
//  Myterest
//
//  Created by Mikael Teklehaimanot on 3/25/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import PinterestSDK

//Using local Board data model instead of PDKBoard
class Board {

    var boardID: String
    var boardURL: String
    var boardDescription: String
    var name: String
    var createdAt: String
    var imageInfo: NSDictionary
    
    
    init(boardID: String,
         boardURL: String,
         boardDescription:String,
         name: String,
         createdAt: String,
         imageInfo: NSDictionary) {
        
        self.boardID = boardID
        self.boardURL = boardURL
        self.boardDescription = boardDescription
        self.name = name
        self.createdAt = createdAt
        self.imageInfo = imageInfo
        
    }
    
    convenience init(board: NSDictionary) {
        
        let boardID = board["id"] as! String
        let boardURL = board["url"] as! String
        let description = board["description"] as! String
        let name = board["name"] as! String
        let createdAt = board["created_at"] as! String
        let imageInfo = board["image"] as! NSDictionary
        
        self.init(boardID: boardID,
                  boardURL: boardURL,
                  boardDescription: description,
                  name: name,
                  createdAt: createdAt,
                  imageInfo: imageInfo)
        
    }

    
}
