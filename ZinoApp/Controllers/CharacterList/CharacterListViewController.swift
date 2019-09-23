//
//  ViewController.swift
//  ZinoApp
//
//  Created by Fabrizio Sposetti on 02/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import UIKit
import Alamofire

class CharacterListViewController: UIViewController {
    
    @IBOutlet weak var charactersCollection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var loadingData = false
    var limit:Int = CONSTANTS.CHARACTER_LIMMIT
    var offset:Int = CONSTANTS.CHRACTERS_OFFSET
    var totalCharacters: Int = 0
    var callServiceAgain = false
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let reusableCellIdentifier = "CharacterUICollectionViewCell"
    
    var searching = false
    
    var characters: [CharacterModel] = []
    var prevImportList: [CharacterModel] = []

    
    var searchTask: DispatchWorkItem?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = Text.MarvelCharacters.description
        configureCollectionView()
        configureSearchBar()
        getCharacters(limit: limit, offset: offset, nameStartsWith: nil)
    }
    
    private func configureCollectionView() {
        charactersCollection.delegate = self
        charactersCollection.dataSource = self
        charactersCollection.register(UINib(nibName: CharacterUICollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: CharacterUICollectionViewCell.nibName)        
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.showsCancelButton = false
    }
    
    private func getCharacters(limit: Int, offset: Int, nameStartsWith: String?) {
        showActivityIndicator(activityIndicator: activityIndicator)
        DAO.Instance.getCharacters(limit: limit, offset: offset, nameStartsWith: nameStartsWith) { [weak self] response, error in
            guard let self = self else { return }
            self.stopActivityIndicator(activityIndicator: self.activityIndicator)
            if error == nil {
                self.totalCharacters = (response?.data?.total)!
                
                if let _ = nameStartsWith {
                    self.handleFilterResults(characters: (response?.data?.results)!)
                } else {
                    self.handleScrollResults(characters: (response?.data?.results)!)
                }
                
                self.loadingData = false
                self.charactersCollection.reloadData()
                self.callServiceAgain = false
                self.searching = false
            } else {
                self.showToast(message: Text.MessageErrorCharacters.description,
                               width: CONSTANTS.TOAST_SIZE,
                               backgroundColor: UIColor.orange)
                self.callServiceAgain = true
            }

        }
    }
    
    private func handleScrollResults(characters: [CharacterModel]) {
        let newImport: [CharacterModel] = characters
        self.characters += newImport
        self.offset += characters.count
    }
    
    private func handleFilterResults(characters: [CharacterModel]) {
        self.characters = characters
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if callServiceAgain {
            getCharacters(limit: limit, offset: offset, nameStartsWith: nil)
        }
    }
    
}


extension CharacterListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.characters.count == 0 && activityIndicator.isHidden) {
            charactersCollection.setEmptyMessage(Text.EmptyMessage.description)
        } else {
            charactersCollection.restore()
        }
        return self.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellIdentifier, for: indexPath) as! CharacterUICollectionViewCell
        
        let url = ("\(characters[indexPath.row].thumbnail!.path ?? "")/landscape_large.\(characters[indexPath.row].thumbnail!.thumbnailExtension ?? "value")")
        setImageFrom(url, cell.characterImage)
        cell.setCellData(character: characters[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = CONSTANTS.NUMBER_OF_CELLS_IN_ROW
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size , height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController: CharacterDetailViewController = UIStoryboard(name: Storyboards.CharacterDetail, bundle: nil)
            .instantiateViewController(withIdentifier: "characterDetailViewController") as! CharacterDetailViewController
        
        viewController.character = characters[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == totalCharacters - 1 {
            return
        }
        if indexPath.row == characters.count - 1 && !loadingData {
            self.loadingData = true
            self.getCharacters(limit:limit, offset:offset, nameStartsWith: nil)
        }
    }
    
}

extension  CharacterListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var text: String? = searchText
        if searchText == "" {
            text = nil
            self.characters = []
        }
        
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.offset = 0
            if !self.searching {
                self.searching = true
                self.getCharacters(limit: self.limit, offset: self.offset, nameStartsWith: text)
            }
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.50, execute: task)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
}

