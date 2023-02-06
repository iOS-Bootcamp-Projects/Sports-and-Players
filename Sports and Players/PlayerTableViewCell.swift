//
//  PlayerTableViewCell.swift
//  Sports and Players
//
//  Created by Aamer Essa on 12/12/2022.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var playerWeight: UILabel!
    @IBOutlet weak var playerHeight: UILabel!
    @IBOutlet weak var playerAge: UILabel!
    @IBOutlet weak var playerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
