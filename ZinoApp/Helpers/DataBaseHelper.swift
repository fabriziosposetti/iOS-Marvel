//
//  DataBaseHelper.swift
//  ZinoApp
//
//  Created by Fabrizio Sposetti on 04/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import Foundation
import RealmSwift

public class DataBaseHelper {
    
    public static let instance = DataBaseHelper()
    
    
    public static func getRealm() -> Realm? {
        do {
            return try Realm()
        } catch let error {
            print(error.localizedDescription)
            fatalError()
        }
    }
    
    func getListOfCharacters() -> Results<CharacterModel>? {
        do {
            guard let realm = DataBaseHelper.getRealm() else { return nil }
            return realm.objects(CharacterModel.self)
        }
    }
    
    
    func characterExists(character: CharacterModel) -> Bool? {
        do {
            guard let realm = DataBaseHelper.getRealm() else { return nil }
            return realm.object(ofType: CharacterModel.self, forPrimaryKey: character.id) != nil
        }
    }
    
    func saveCharacter(_ character: CharacterModel) {
        do {
            guard let realm = DataBaseHelper.getRealm() else { return }
            realm.beginWrite()
            realm.create(CharacterModel.self, value: character, update: true)
            try realm.commitWrite()
        } catch let error {
            print("error: " + error.localizedDescription)
        }
    }

    func deleteCharacter(_ character: CharacterModel) {
        do {
            guard let realm = DataBaseHelper.getRealm() else { return }
            realm.beginWrite()
            let object = realm.objects(CharacterModel.self).filter("id=%@", character.id)
            realm.delete(object)
            try realm.commitWrite()
        } catch let error {
            print("error: " + error.localizedDescription)
        }
    }
    
}
