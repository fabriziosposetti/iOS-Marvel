//
//  CharacterDetailViewController.swift
//  ZinoApp
//
//  Created by Fabrizio Sposetti on 02/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import UIKit
import Kingfisher


class CharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var lblCharacterName: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var tvDescription: UITextView!
    
    
    var character: CharacterModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = character?.name
        updateView()
    }
    
    func updateView() {        
        let url = ("\(character?.thumbnail!.path ?? "")/standard_large.\(character?.thumbnail!.thumbnailExtension ?? "value")")
        setImageFrom(url, characterImage)
        lblCharacterName.text = character?.name
        tvDescription.text = character?.getDescription()
        updateFavouriteIcon()
    }
    
    @IBAction func btnFavTapped(_ sender: Any) {
        var message = ""
        let alert = UIAlertController(title: Text.Favourites.description,
                                      message: message,
                                      preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: Text.No.description, style: .default, handler: nil)
        alert.addAction(noAction)
        
        if isFavourite() {
            message = String(format: Text.CharacterDeleteMessage.description, character!.name ?? "")
            let yesAction = UIAlertAction(title: Text.Yes.description, style: .default) { [weak self] _ in
                guard let self = self else { return }
                DAO.Instance.deleteFavouriteFromDB(character: self.character!)
                self.character?.isFavourite = false
                self.updateFavouriteIcon()
            }
            alert.addAction(yesAction)
        } else {
            message = Text.AddFavouriteMessage.description
            let actionYes = UIAlertAction(title: Text.Yes.description, style: .default) { [weak self] _ in
                guard let self = self else { return }
                DAO.Instance.addFavouriteToDB(character: self.character!)
                self.character?.isFavourite = true
                self.updateFavouriteIcon()
                self.showToast(message: Text.CharacterFavouriteAdded.description, width: CONSTANTS.TOAST_SIZE, backgroundColor: UIColor.greenFavouriteAdd())
            }
            alert.addAction(actionYes)
        }
        
        alert.message = message
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavouriteIcon()
    }
    
    private func isFavourite() -> Bool {
        if let character = character, let exists = DAO.Instance.characterExists(character: character) {
           return exists
        }
        return false
    }
    
    private func updateFavouriteIcon() {
        if isFavourite() {
            btnFavourite.setImage(Icons.FAVOURITE_ADDED, for: .normal)
        } else {
            btnFavourite.setImage(Icons.FAVOURITE, for: .normal)
        }
    }

}
