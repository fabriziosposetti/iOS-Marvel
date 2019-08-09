//
//  FavouritesCharactersViewController.swift
//  ZinoApp
//
//  Created by Fabrizio Sposetti on 04/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import UIKit
import RealmSwift


class FavouritesCharactersViewController: UIViewController {
    
    @IBOutlet weak var favouritesTableView: UITableView!
    
    var notificationToken: NotificationToken?
    let characterResults = DataBaseHelper.instance.getListOfCharacters()
    var lblEmptyTable: UILabel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = Text.FavouritesCharacters.description
        configureTableView()
        addResultsObservers()
        evaluateContentTableView()
    }
    
    private func evaluateContentTableView() {
        if self.characterResults?.count == 0 {
            showEmptyLabel()
        } else {
            self.lblEmptyTable?.isHidden = true
        }
    }
    
    private func addResultsObservers() {
        // Set results notification block
        guard let results = characterResults else { return }
        self.notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.favouritesTableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the TableView
                self.evaluateContentTableView()
                self.favouritesTableView.beginUpdates()
                self.favouritesTableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.favouritesTableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.favouritesTableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.favouritesTableView.endUpdates()
                break
            case .error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break
            }
        }
    }
    
    private func configureTableView() {
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
        favouritesTableView.register(UINib(nibName: FavouriteCharacterTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: FavouriteCharacterTableViewCell.nibName)
        favouritesTableView.tableFooterView = UIView()
    }
    
    private func showDeleteMessageAlert(characterIndex: Int) {
        guard let results = characterResults else { return }
        let message = String(format: Text.CharacterDeleteMessage.description, results[characterIndex].name ?? "")
        
        let alert = UIAlertController(title: Text.DeleteFavourite.description,
                                      message: message,
                                      preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: Text.No.description, style: .default, handler: nil)
        let yesAction = UIAlertAction(title: Text.Yes.description, style: .default) { [weak self] _ in
            guard let self = self else { return }
            DAO.Instance.deleteFavouriteFromDB(character: results[characterIndex])
            self.evaluateContentTableView()
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showEmptyLabel() {
       lblEmptyTable = UILabel(frame: CGRect(x: 0, y: 0, width: self.favouritesTableView.bounds.size.width, height: self.favouritesTableView.bounds.size.height))
        lblEmptyTable!.text = Text.NoFavouritesCaracters.description
        lblEmptyTable!.textColor = UIColor.blueEmptyTable()
        lblEmptyTable!.textAlignment = NSTextAlignment.center
        self.favouritesTableView.backgroundView = lblEmptyTable
    }

}

extension FavouritesCharactersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCharacterTableViewCell", for: indexPath) as! FavouriteCharacterTableViewCell
        
        let url = ("\(characterResults?[indexPath.row].thumbnail!.path ?? "")/landscape_large.\(characterResults?[indexPath.row].thumbnail!.thumbnailExtension ?? "value")")
        
        setImageFrom(url, cell.characterImage)
        cell.setData(character: characterResults?[indexPath.row] ?? nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CONSTANTS.TABLE_VIEW_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: Text.Delete.description) { [weak self] _, indexPath in
            guard let self = self else { return }
            self.showDeleteMessageAlert(characterIndex: indexPath.row)
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
}
