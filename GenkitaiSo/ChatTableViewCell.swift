//
//  ChatTableViewCell.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 25/02/23.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
//
//// Reuse or create a cell.
//   let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
//
//   // For a standard cell, use the UITableViewCell properties.
//   cell.textLabel!.text = "Title text"
//   cell.imageView!.image = UIImage(named: "bunny")
//   return cell
