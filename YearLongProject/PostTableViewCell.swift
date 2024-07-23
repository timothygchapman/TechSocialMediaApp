//
//  MyTableViewCell.swift
//  YearLongProject
//
//  Created by Timothy Chapman on 3/25/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "MyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTableViewCell", bundle: nil)
    }
    
    public func configure(with post: Post) {
        user.text = post.authorUserName
        date.text = post.createdDate
        bodyText.text = post.body
        numberOfComments.text = String(post.numComments)
        numberOfLikes.text = String(post.likes)
        likesCount = post.likes
    }
    
    @IBOutlet var user: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var bodyText: UILabel!
    @IBOutlet var numberOfComments: UILabel!
    @IBOutlet var numberOfLikes: UILabel!
    @IBOutlet var likesButton: UIButton!
    
    var likesCount: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likesButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        likesButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .selected)
        
        likesButton.setBackgroundImage(UIImage(), for: .normal)
        likesButton.setBackgroundImage(UIImage(), for: .selected)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func likesButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            likesCount += 1
        } else {
            likesCount -= 1
        }
        
        numberOfLikes.text = "\(likesCount)"
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        
    }
    
}
