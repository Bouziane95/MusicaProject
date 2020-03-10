//
//  ChatTableviewCell.swift
//  Musica
//
//  Created by Bouziane Bey on 10/03/2020.
//  Copyright © 2020 Bouziane Bey. All rights reserved.
//

import UIKit

class ChatTableviewCell: UITableViewCell {
    
    @IBOutlet weak var imageProfil: UIImageView!
    @IBOutlet weak var nameProfil: UILabel!
    @IBOutlet weak var msgProfil: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
