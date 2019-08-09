//
//  CharacterUICollectionViewCell.swift
//  ZinoApp
//
//  Created by Fabrizio Sposetti on 02/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import UIKit
import Kingfisher


class CharacterUICollectionViewCell: UICollectionViewCell {
    
    static let nibName = "CharacterUICollectionViewCell"

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var lblCharacterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setCellData(character: CharacterModel?) {
        if let character = character {
            lblCharacterName.text = character.name
        }
    }
    
    
    func setImageFrom(_ url: String) {
        let urlResource = URL(string: url)!
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
            >> RoundCornerImageProcessor(cornerRadius: 20)
        self.characterImage.kf.indicatorType = .activity
        self.characterImage.kf.setImage(
            with: urlResource,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]) {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        
    }

}
