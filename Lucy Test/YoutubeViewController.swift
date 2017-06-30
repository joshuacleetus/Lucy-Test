//
//  YoutubeViewController.swift
//  Lucy Test
//
//  Created by Joshua Cleetus on 6/30/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class YoutubeViewController: UIViewController {
    
    var webV: UIWebView! = UIWebView.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        webV.frame = CGRect(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(webV)
        
        loadYoutube(videoID: "8hP9D6kZseM")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadYoutube(videoID:String) {
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")
            else { return }
        webV.loadRequest( URLRequest(url: youtubeURL) )
    }
    
}
