//
//  BoardPinsViewController.swift
//  Myterest
//
//  Created by Mikael Teklehaimanot on 3/26/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import PinterestSDK
import AlamofireImage
import AVFoundation

typealias PDKPinsViewControllerLoadBlock = (_ success: PDKClientSuccess?, _ failure: PDKClientFailure?) -> Void

class BoardPinsViewController: UIViewController, UINavigationBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var board: Board!
    var dataLoadBlock: PDKPinsViewControllerLoadBlock?
    
    var pinData = [PDKPin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup navbar
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 65))
        navBar.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
        navBar.delegate = self
        let navItems = UINavigationItem()
        navItems.title = "\(board.name)"
        navItems.leftBarButtonItem = UIBarButtonItem(title: "back", style: .done, target: self, action: #selector(BoardPinsViewController.goBack))
        navItems.leftBarButtonItem?.tintColor = UIColor.black
        navBar.items = [navItems]
        view.addSubview(navBar)
        
        //collectionView configuration
        collectionView.contentInset = UIEdgeInsets(top: 65, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        
        //cellectionView layout configuration
        let layout = collectionView.collectionViewLayout as! PinLayout
        layout.delegate = self
        layout.numberOfColumns = 2
        layout.cellPadding = 5
        
        //get pins data
        let completionHandler: PDKClientSuccess = {
            response in
            guard let response = response  else {
                return
            }
            guard let pins = response.pins() as? [PDKPin] else {
                return
            }
            
            self.pinData = pins
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        if (self.dataLoadBlock != nil) {
            self.dataLoadBlock!(completionHandler, nil)
        }
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }

}

extension BoardPinsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pin = pinData[indexPath.item]
        let pinDetailVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PinDetailVC") as! PinDetailViewController
        pinDetailVC.pin = pin
        self.navigationController?.pushViewController(pinDetailVC, animated: true)
    }
    
}

extension BoardPinsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pinData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinCell", for: indexPath) as? PinCell else {
            return UICollectionViewCell()
        }
        let pin = pinData[indexPath.item]
        cell.pin = pin
        return cell
    }

}

extension BoardPinsViewController: PinLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        //TODO: OPtimize with Operation to dynamically get height of image
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: CGSize(width: 200, height: 400), insideRect: boundingRect)
            
        return rect.height
        
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let pin = pinData[indexPath.item]
        let descriptionHeight = heightForText(pin.descriptionText, width: width-24)
        let height = 4 + 17 + 4 + descriptionHeight + 12
        return height
    }
    
    func heightForText(_ text: String, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 10)
        let rect = NSString(string: text).boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
    
}









