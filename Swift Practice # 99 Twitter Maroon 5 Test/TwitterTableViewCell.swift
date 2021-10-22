//
//  TwitterTableViewCell.swift
//  Swift Practice # 99 Twitter Maroon 5 Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/22.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {

    
    //上
    @IBOutlet weak var blackNameLabel: UILabel!         //名字粗體
    @IBOutlet weak var atNameLabel: UILabel!            //@名字
    @IBOutlet weak var dateLabel: UILabel!              //發布日期
    
    //中
    @IBOutlet weak var textContentView: UITextView!     //推文內容
    @IBOutlet weak var profileImageview: UIImageView!   //大頭貼
    
    //下
    @IBOutlet weak var commentLabel: UILabel!           //留言
    @IBOutlet weak var retweetLabel: UILabel!           //轉發
    @IBOutlet weak var likeLabel: UILabel!              //喜歡
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
