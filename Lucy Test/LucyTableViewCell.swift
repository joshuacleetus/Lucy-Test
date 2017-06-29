//
//  LucyTableViewCell.swift
//  Lucy Test
//
//  Created by Joshua Cleetus on 6/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

class LucyTableViewCell: UITableViewCell {

    var myLabel1: UILabel!
    var myLabel2: UILabel!
    var myButton1 : UIButton!
    var myButton2 : UIButton!
    
    var profileImageView : UIImageView!
    var nameLabel: UILabel!
    var subjectLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let gap : CGFloat = 20
        let labelHeight: CGFloat = 20
        let labelOffset: CGFloat = 120
        let imageSize : CGFloat = 60
        let imageBorderWidth : CGFloat = 1
        
        profileImageView = UIImageView()
        profileImageView.frame = CGRect(gap, gap, imageSize, imageSize)
        profileImageView.layer.cornerRadius = imageSize/2
        profileImageView.layer.borderColor = UIColor.blue.cgColor
        profileImageView.layer.borderWidth = imageBorderWidth
        profileImageView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        
        nameLabel = UILabel()
        nameLabel.frame = CGRect(profileImageView.frame.origin.x+profileImageView.frame.size.width+gap, profileImageView.frame.origin.y, self.frame.size.width-labelOffset, labelHeight)
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(nameLabel)
        
        subjectLabel = UILabel()
        subjectLabel.frame = CGRect(nameLabel.frame.origin.x, profileImageView.frame.origin.y+nameLabel.frame.size.height, self.frame.size.width-labelOffset, labelHeight*2)
        subjectLabel.textColor = UIColor.lightGray
        subjectLabel.numberOfLines = 2
        subjectLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(subjectLabel)
        
    }

}
