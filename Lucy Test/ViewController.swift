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
    static let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6ImFjY2VzcyIsInR5cGUiOiJhY2Nlc3MifQ.eyJ1c2VySWQiOiI1OGJlMGNkZGExNzlmNTAxNmEwMzhkYzkiLCJpYXQiOjE0OTg2ODEzMDUsImV4cCI6MTQ5ODc2NzcwNSwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdCIsImlzcyI6ImZlYXRoZXJzIiwic3ViIjoiYW5vbnltb3VzIn0.yZhoWY7CbLdqhGjSnyIo-gyU1Fr50xAUHgNXZGgMyd8"
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataArray: [Any] = []
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
        
        self.authenticateWithFeathers()
        
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
        return cell
    }
    
    func authenticateWithFeathers() {
        let feathersRestApp = Feathers(provider: SocketProvider(baseURL: URL(string: "https://peregrine.hellolucy.io/")!, configuration: [], timeout: 5))
        feathersRestApp.authenticate([
            "strategy": Constants.strategy,
            "access_token": Constants.accessToken
            ])
            .start()
        
        let userService = feathersRestApp.service(path: "threads")
        let query = Query()
            .eq(property: "account_id", value: "f4ehbqhbxqnaigx6w3b7safy1").limit(10)
        userService.request(.find(query: query)).on(value: { response in
            self.dataArray = response.data.value as! [Any]
            self.tableView?.reloadData()
        }).startWithFailed { (error) in
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

