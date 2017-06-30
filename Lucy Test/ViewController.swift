//
//  ViewController.swift
//  Lucy Test
//
//  Created by Joshua Cleetus on 6/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//



import UIKit
import Feathers
import FeathersSwiftSocketIO
import SocketIO
import SwiftyJSON

struct Constants {
    static let strategy = "jwt"
    static let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6ImFjY2VzcyIsInR5cGUiOiJhY2Nlc3MifQ.eyJ1c2VySWQiOiI1OTU2NTkzNTA3ZWIyNTAwMTFmODk0NTEiLCJpYXQiOjE0OTg4MzEyNTcsImV4cCI6MTQ5ODkxNzY1NywiYXVkIjoiaHR0cDovL2xvY2FsaG9zdCIsImlzcyI6ImZlYXRoZXJzIiwic3ViIjoiYW5vbnltb3VzIn0.IxiDUTiGzaiumz8oDvpT37ZJ7NhtsUGjXcezYpGHO1g"
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate {
    
    var dataArray: [Any] = []
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(rightButtonPressed))
        
        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
        
        self.authenticateWithFeathers()
        
        registerForPreviewing(with: self, sourceView: tableView!)
        
        self.authenticateWithFeathers()
        
    }
    
    func actionTapped() {
        let cleanVC = CleanViewController()
        self.navigationController?.pushViewController(cleanVC, animated: true)
    }
    
    func rightButtonPressed() {
        let youtubeVC = YoutubeViewController()
        self.navigationController?.pushViewController(youtubeVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = LucyTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myIdentifier")
        let json = JSON(self.dataArray[indexPath.row])
        if let url = URL(string: "https://imgh.us/Icon-App-76x76@1x.png") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        cell.profileImageView.image = UIImage(data: data)
                    }
                }
                
            }
        }

        let title = json["last_message_from"][0]["name"].stringValue
        let email = json["last_message_from"][0]["email"].stringValue
        let subject = json["snippet"].stringValue
        if !title.isEmpty {
            cell.nameLabel.text = title
        } else if !email.isEmpty {
            cell.nameLabel.text = email
        }
        if !subject.isEmpty {
            cell.subjectLabel.text = subject
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        let json = JSON(self.dataArray[indexPath.row])
        detailVC.jsonObject = json
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // let the controller to know that able to edit tableView's row
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        // add the action button you want to show when swiping on tableView's cell , in this case add the delete button.
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action , indexPath) -> Void in
            
            // Your delete code here.....
            self.dataArray .remove(at: indexPath.row)
            tableView.reloadData()
            
        })
        
        // You can set its properties like normal button
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
    func authenticateWithFeathers() {
        let feathersRestApp = Feathers(provider: SocketProvider(baseURL: URL(string: "http://138.197.231.183:32208/")!, configuration: [], timeout: 5))
        feathersRestApp.authenticate([
            "strategy": Constants.strategy,
            "access_token": Constants.accessToken
            ])
            .start()
        
        let userService = feathersRestApp.service(path: "threads")
        let query = Query()
            .eq(property: "account_id", value: "dyxn5j1whfh7qhj4xznguj9of").limit(10)
        userService.request(.find(query: query)).on(value: { response in
            self.dataArray = response.data.value as! [Any]
            self.tableView?.reloadData()
        }).startWithFailed { (error) in
            print(error)
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView?.indexPathForRow(at: location) {
            //This will show the cell clearly and blur the rest of the screen for our peek.
            previewingContext.sourceRect = (tableView?.rectForRow(at: indexPath))!
            return viewControllerForIndexPath(indexPath: indexPath)
        }
        return nil
    }
    
    func viewControllerForIndexPath(indexPath: IndexPath) -> UIViewController {
        let peepVC = DetailViewController()
        let json = JSON(self.dataArray[indexPath.row])
        peepVC.jsonObject = json
        return peepVC
    }
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

