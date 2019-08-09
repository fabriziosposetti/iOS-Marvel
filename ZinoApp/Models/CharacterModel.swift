//
//  CharacterModel.swift
//  ZinoApp
//
//  Created by Fabrizio Sposetti on 02/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import Foundation
import RealmSwift

class CharacterModel: Object, Codable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var resultDescription: String?
    @objc dynamic var thumbnail: Thumbnail?
    @objc dynamic var isFavourite: Bool = false
    
    public func getDescription() -> String {
        return description == "" ? "No description Found" : "\(resultDescription ?? "")"
    }
    
    override public static func primaryKey() -> String {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case thumbnail
    }
    
}


class Thumbnail: Object, Codable {
    @objc dynamic var path: String?
    @objc dynamic var thumbnailExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}
