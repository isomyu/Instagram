//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by 磯翔野 on 2019/01/31.
//  Copyright © 2019 shono.iso. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setComment(_ comment:Comment) {
        self.nameLabel.text = comment.name
        
        self.commentLabel.text = comment.caption
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: comment.date!)
        self.dateLabel.text = dateString
        
    }
    
}
