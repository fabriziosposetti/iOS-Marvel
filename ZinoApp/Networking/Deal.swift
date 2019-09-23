//
//  Deal.swift
//  ZinoApp
//
//  Created by Fabrizio Sposetti on 02/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import Foundation
import CommonCrypto

struct KeyDict {
    let publicKey: String!
    let privateKey: String!
}


public class Deal {
    
    public static var instance = Deal()
    private var keys: NSDictionary?

    func getKeys() -> KeyDict {
        if let path = Bundle.main.path(forResource: "apikeys", ofType: "plist") {
            self.keys = NSDictionary(contentsOfFile: path)!
        }
        
        if let data = keys {
            return KeyDict(publicKey: (data["publicKey"] as! String), privateKey: (data["privateKey"] as! String))
        } else {
            return KeyDict(publicKey: "", privateKey: "")
        }
    }
    
    func getCharactersUrl(limit: Int, offset: Int, nameStartsWith: String? = nil) -> URLRequest {
        let dict: KeyDict = self.getKeys()
        let ts = "thesoer"
        let hash = md5Hash(str: "\(ts)\(dict.privateKey!)\(dict.publicKey!)")

        
        var queryItems = [URLQueryItem(name: "apikey", value: "\(dict.publicKey!)"),
                          URLQueryItem(name: "hash", value: "\(hash)"),
                          URLQueryItem(name: "ts", value: "\(ts)"),
                          URLQueryItem(name: "limit", value: "\(limit)"),
                          URLQueryItem(name: "offset", value: "\(offset)")]
        
        if let filter = nameStartsWith {
            queryItems.append(URLQueryItem(name: "nameStartsWith", value: filter))
        }
    
        var urlComps = URLComponents(string: "https://gateway.marvel.com:443/v1/public/characters")!

        urlComps.queryItems = queryItems
        
        let url = (urlComps.url!)
        let request = URLRequest(url: url)
        return request
        
    }
    
    
    func md5Hash(str: String) -> String {
        if let strData = str.data(using: String.Encoding.utf8) {
            var digest = [UInt8](repeating: 0, count:Int(CC_MD5_DIGEST_LENGTH))
            _ = strData.withUnsafeBytes {
                CC_MD5($0.baseAddress, UInt32(strData.count), &digest)
            }
            var md5String = ""
            for byte in digest {
                md5String += String(format:"%02x", UInt8(byte))
            }
            return md5String
        }
        return ""
    }
    
}


