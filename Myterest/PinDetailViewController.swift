//
//  PinDetailViewController.swift
//  Myterest
//
//  Created by Mikael Teklehaimanot on 3/27/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import PinterestSDK

class PinDetailViewController: UIViewController, UINavigationBarDelegate {
    
    @IBOutlet weak var pinImageView: PinImageView!
    @IBOutlet weak var pinDescriptionLabel: UILabel!
    @IBOutlet weak var pinLinkButton: UIButton!

    var pin: PDKPin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navBar
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 65))
        navBar.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
        navBar.delegate = self
        let navItems = UINavigationItem()
        navItems.title = "Pin"
        navItems.leftBarButtonItem = UIBarButtonItem(title: "back", style: .done, target: self, action: #selector(PinDetailViewController.goBack))
        navItems.leftBarButtonItem?.tintColor = UIColor.black
        navBar.items = [navItems]
        view.addSubview(navBar)
        
        if let pin = pin {
            pinImageView.setImageWith(pin.smallestImage().url)
            pinDescriptionLabel.text = pin.descriptionText
            pinLinkButton.setTitle("Open pin in pinterest", for: .normal)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func urlButtonTapped(sender: UIButton) {
        if let pin = pin {
            UIApplication.shared.openURL(pin.pinURL)
        }
    }

}
