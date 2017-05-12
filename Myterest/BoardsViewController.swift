//
//  BoardsViewController.swift
//  Myterest
//
//  Created by Mikael Teklehaimanot on 3/25/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import PinterestSDK


class BoardsViewController: UIViewController, UINavigationBarDelegate {
    
    var boardsData = [Board]()
    var session: URLSession!
    var cache: NSCache<AnyObject, UIImage>!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure TableView
        tableView.rowHeight = 309.0
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        //Configure NavBar
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 65))
        navBar.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
        navBar.delegate = self
        let navItems = UINavigationItem()
        navItems.title = "Boards"
        navBar.items = [navItems]
        view.addSubview(navBar)
        
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: true)
        
        //session manager for downloading images
        session = URLSession.shared
        cache = NSCache()
        
        //Get Users Board Info
        let allFields = PDKBoard.allFields()
        PDKClient.sharedInstance().getAuthenticatedUserBoards(withFields: allFields, success: {
            response in
            if let response = response {

                if let boardData = response.parsedJSONDictionary["data"] as? NSArray {
                    for board in boardData {
                        guard let board = board as? NSDictionary else {
                            return
                        }
                        let newBoard = Board(board: board)
                        self.boardsData.append(newBoard)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
 
                
            }
        }, andFailure: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: Use AVMakeRect to get scaled image for fitting imageView bounds nicely
    func getImage(tableView: UITableView, indexPath: IndexPath, board: Board) {
        if let imageSize60 = board.imageInfo["60x60"] as? NSDictionary {
            if let imageURL = imageSize60["url"] as? String {
                let url = URL(string: imageURL)
                
                session.downloadTask(with: url!, completionHandler: { (url, repsonse, error) in
                    do {
                        let data = try Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            if let thisCell = tableView.cellForRow(at: indexPath) as? BoardCell {
                                let image = UIImage(data: data)
                                thisCell.boardImageView.image = image
                                
                                //Use boardID to cache until i have several pin Images, then use board ID with array of images
                                self.cache.setObject(image!, forKey: board.boardID as AnyObject)
                            }
                        }
                    } catch {
                        
                    }
                }).resume()
                
            }
        }
    }
    
}

extension BoardsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !boardsData.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath) as? BoardCell {
                cell.selectionStyle = .none
                let board = boardsData[indexPath.row]
                cell.board = board
                
                if let image = self.cache.object(forKey: board.boardID as AnyObject) {
                    cell.boardImageView.image = image
                } else {
                    getImage(tableView: tableView, indexPath: indexPath, board: board)
                }
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}

extension BoardsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let board = boardsData[indexPath.row]
        let boardPinsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BoardPinsVC") as! BoardPinsViewController
        boardPinsVC.board = board
        boardPinsVC.dataLoadBlock = {
            success, failure in
            PDKClient.sharedInstance().getBoardPins(board.boardID, fields: PDKPin.allFields(), withSuccess: success, andFailure: failure)
        }
        
        self.navigationController?.pushViewController(boardPinsVC, animated: true)
    }
    
}



































