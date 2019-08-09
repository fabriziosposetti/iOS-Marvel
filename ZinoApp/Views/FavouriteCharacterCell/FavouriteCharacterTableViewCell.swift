//
//  FavouriteCharacterTableViewCell.swift
//  ZinoApp
//
//  Created by Fabrizio Sposetti on 04/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import UIKit

class FavouriteCharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCharacterName: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    
    static let nibName = "FavouriteCharacterTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setData(character: CharacterModel?) {
        if let c = character {
            lblCharacterName.text = c.name
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
