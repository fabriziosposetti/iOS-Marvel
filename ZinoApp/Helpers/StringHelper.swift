//
//  StringHelper.swift
//  ZinoApp
//
//  Created by Fabrizio Sposetti on 02/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import Foundation

protocol LocalizedEnum: CustomStringConvertible {}

class BundleMarker {}

extension LocalizedEnum where Self: RawRepresentable, Self.RawValue == String {
    var description: String {
        let tableName = "Strings"
        let bundle =  Bundle(for: BundleMarker.self)
        return NSLocalizedString(self.rawValue,
                                 tableName: tableName,
                                 bundle: bundle,
                                 value: "",
                                 comment: "")
    }
}

extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}

enum Text: String, LocalizedEnum {
    
    case Error
    case MarvelCharacters
    case FavouritesCharacters
    case Favourites
    case AddFavouriteMessage
    case Yes
    case No
    case DeleteFavourite
    case CharacterDeleteMessage
    case Delete
    case CharacterFavouriteAdded
    case NoFavouritesCaracters
    case MessageErrorCharacters
    case EmptyMessage
}
