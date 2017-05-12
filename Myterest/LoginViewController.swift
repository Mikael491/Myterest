//
//  ViewController.swift
//  Myterest
//
//  Created by Mikael Teklehaimanot on 3/23/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import PinterestSDK

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginTapped(sender: UIButton) {
        loginButton.isEnabled = false
        let permissions = [PDKClientReadPublicPermissions,
                          PDKClientWritePublicPermissions,
                          PDKClientReadRelationshipsPermissions,
                          PDKClientWriteRelationshipsPermissions]
        PDKClient.sharedInstance().authenticate(withPermissions: permissions, from: self, withSuccess: {
            response in
            if let response = response {
                DispatchQueue.main.async {
                    let boardsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BoardsVC")
                    self.navigationController?.pushViewController(boardsVC, animated: true)
                }
            }
        }, andFailure: {
            error in
            print("MIKE: There was an error authenticating...\(error)")
            DispatchQueue.main.async {
                self.loginButton.isEnabled = true
            }
        })
    }

}

