//
//  DetailViewController.swift
//  Lucy Test
//
//  Created by Joshua Cleetus on 6/30/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SwiftyJSON

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(0, 0, self.frame.height, thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(0, self.frame.height - thickness, UIScreen.main.bounds.width, thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(0, 0, thickness, self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(self.frame.width - thickness, 0, thickness, self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}

class DetailViewController: UIViewController {
    
    var jsonObject: JSON = []
    var profileImageView : UIImageView!
    var nameLabel: UILabel!
    var subjectLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        var title = jsonObject["last_message_from"][0]["name"].stringValue
        if title.isEmpty {
            title = jsonObject["last_message_from"][0]["email"].stringValue
        }
        
        let subject = jsonObject["subject"].stringValue
        
        self.navigationItem.titleView = setTitle(title: title, subtitle: subject)
        
        let dateLabel = UILabel(frame: CGRect(0, 66, self.view.frame.size.width, 40))
        dateLabel.backgroundColor = UIColor.clear
        dateLabel.textColor = UIColor.lightGray
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.text = title
        dateLabel.layer.addBorder(edge: .bottom, color: .gray, thickness: 0.5)
        self.view.addSubview(dateLabel)
        
        let unixTimestamp = jsonObject["last_message_timestamp"].double
        let date = Date(timeIntervalSince1970: Double(unixTimestamp!)/1000)
        let timeInterval = date.timeIntervalSinceNow
        
        let dayString = dayDifference(from: timeInterval)
        
        dateLabel.text = dayString
        
        profileImageView = UIImageView()
        profileImageView.frame = CGRect( 20, 66+40+20, 50, 50)
        profileImageView.layer.cornerRadius = 50/2
        profileImageView.layer.borderColor = UIColor.blue.cgColor
        profileImageView.layer.borderWidth = 1
        profileImageView.clipsToBounds = true
        self.view.addSubview(profileImageView)
        if let url = URL(string: "https://imgh.us/Icon-App-76x76@1x.png") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.profileImageView.image = UIImage(data: data)
                    }
                }
                
            }
        }
        
        nameLabel = UILabel()
        nameLabel.frame = CGRect( 90, profileImageView.frame.origin.y, self.view.frame.size.width-110, 20)
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.view.addSubview(nameLabel)
        
        nameLabel.text = title
        
        let snippet = jsonObject["snippet"].stringValue

        
        subjectLabel = UILabel()
        subjectLabel.frame = CGRect(nameLabel.frame.origin.x, nameLabel.frame.origin.y+20+20, nameLabel.frame.size.width, 300)
        subjectLabel.backgroundColor = UIColor.clear
        subjectLabel.textColor = UIColor.lightGray
        subjectLabel.numberOfLines = 0
        subjectLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(subjectLabel)
        subjectLabel.textAlignment = .left
        subjectLabel.text = snippet

        print(dayString)

        print(jsonObject)
        
    }
    
    override func viewDidLayoutSubviews() {
        subjectLabel.sizeToFit()
    }
    
    func dayDifference(from interval : TimeInterval) -> String
    {
        let calendar = NSCalendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(abs(day)) days ago" }
            else { return "In \(day) days" }
        }
    }
    
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(0, -2, 0, 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(0, 18, 0, 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(0, 0, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        return titleView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
