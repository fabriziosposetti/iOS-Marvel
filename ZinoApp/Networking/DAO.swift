//
//  DAO.swift
//  ZinoApp
//
//  Created by Fabrizio Sposetti on 02/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import Foundation

public class DAO {
    
    public static let Instance = DAO()
    
    func getCharacters(limit: Int, offset: Int, nameStartsWith: String? = nil, completionHandler: @escaping HandleCharactersResponse) {
        Service.instance.getCharacters(limit: limit, offset: offset, nameStartsWith: nameStartsWith, completionHandler: completionHandler)
    }
    
    func addFavouriteToDB(character: CharacterModel) {
        DataBaseHelper.instance.saveCharacter(character)
    }
    
    func deleteFavouriteFromDB(character: CharacterModel) {
        DataBaseHelper.instance.deleteCharacter(character)
    }
    
    
    func characterExists(character: CharacterModel) -> Bool? {
        return DataBaseHelper.instance.characterExists(character: character)
    }
}
