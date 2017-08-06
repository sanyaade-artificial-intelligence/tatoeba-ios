//
//  ContributionCell.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class ContributionCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var contribution: Contribution? = nil {
        didSet {
            guard let contribution = contribution, let imageURL = URL(string: "http://localhost:8080/img/profiles_128/\(contribution.user.imagePath)") else {
                return
            }
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: imageURL) { (data, response, error) in
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
            
            task.resume()
            
            let title: String
            
            if contribution.action == "insert" {
                title = "\(contribution.user.username) added a sentence"
            } else if contribution.action == "update" {
                title = "\(contribution.user.username) edited a sentence"
            } else {
                title = "\(contribution.user.username)"
            }
            
            let titleAttributedText = NSMutableAttributedString(string: title)
            titleAttributedText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18), range: NSRange(location: 0, length: title.characters.count))
            titleAttributedText.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location: 0, length: contribution.user.username.characters.count))
            titleLabel.attributedText = titleAttributedText
            
            let dateTemplate: String
            let timeTemplate: String
            
            if Calendar.current.component(.year, from: contribution.timestamp) == Calendar.current.component(.year, from: Date()) {
                // Weekday, month, day
                dateTemplate = "EEEE MMMM d"
                
                // Hour, minute, am/pm
                timeTemplate = "h mm j"
            } else {
                // Month, day, year
                dateTemplate = "MMMM d yyyy"
                
                // Hour, minute, am/pm
                timeTemplate = "h mm j"
            }
            
            let dateFormat = DateFormatter.dateFormat(fromTemplate: dateTemplate, options: 0, locale: Locale.current)
            let timeFormat = DateFormatter.dateFormat(fromTemplate: timeTemplate, options: 0, locale: Locale.current)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            let dateString = dateFormatter.string(from: contribution.timestamp)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = timeFormat
            let timeString = timeFormatter.string(from: contribution.timestamp)
            
            dateLabel.text = "\(dateString) at \(timeString)"
            contentLabel.text = contribution.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 8
        profileImageView.layer.masksToBounds = true
    }
}
