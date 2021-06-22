//
//  SiteListCell.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 22/06/21.
//

import UIKit

class SiteListCell: UITableViewCell {

    @IBOutlet weak var cellBgView: UIView!
   
    @IBOutlet weak var siteThumbImageView: UIImageView!
    
    @IBOutlet weak var siteChangesLabel: UILabel!
    @IBOutlet weak var siteAddressLabel: UILabel!
    @IBOutlet weak var siteNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
