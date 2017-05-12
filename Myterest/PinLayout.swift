//
//  PinsLayout.swift
//  Myterest
//
//  Created by Mikael Teklehaimanot on 3/27/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit

protocol PinLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    
}

class PinLayoutAttributes : UICollectionViewLayoutAttributes {
    
    //used to calculate image height for collectionView cell, dynamically set cell height based on image
    var imageHeight: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinLayoutAttributes
        copy.imageHeight = imageHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinLayoutAttributes {
            if attributes.imageHeight == imageHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
    
}

class PinLayout: UICollectionViewLayout {
    
    var delegate: PinLayoutDelegate!
    var numberOfColumns = 0
    var cellPadding: CGFloat = 0
    var cache = [PinLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var width: CGFloat {
        get {
            let insets = collectionView!.contentInset
            return collectionView!.bounds.width - (insets.left + insets.right)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    //Must let PinLayout class know about PinLayoutAttributes class
    override class var layoutAttributesClass: AnyClass {
        return PinLayoutAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        if cache.isEmpty {
            let columnWidth = width / CGFloat(numberOfColumns)
            
            var xOffSets = [CGFloat]()
            for column in 0..<numberOfColumns {
                xOffSets.append(CGFloat(column) * columnWidth)
            }
            
            var yOffSets = [CGFloat](repeating: 0, count: numberOfColumns)
            var column = 0
            
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                
                //get image height
                let width = columnWidth - (cellPadding * 2)
                let imageHeight = delegate.collectionView(collectionView!, heightForImageAtIndexPath: indexPath, withWidth: width)
                let descriptionHeight = delegate.collectionView(collectionView!, heightForDescriptionAtIndexPath: indexPath, withWidth: width)
                let height = cellPadding + imageHeight + descriptionHeight + cellPadding
                
                let frame = CGRect(x: xOffSets[column], y: yOffSets[column], width: columnWidth, height: height)
                
                //handles cells inset
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = PinLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                attributes.imageHeight = imageHeight
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffSets[column] = yOffSets[column] + height
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
