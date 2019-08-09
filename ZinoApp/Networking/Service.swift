//
//  Service.swift
//  ZinoApp
//
//  Created by Fabrizio Sposetti on 02/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import Foundation
import Alamofire


typealias HandleCharactersResponse = (MarvelServiceResponse?, String?) -> Void

public class Service {
    
    public static var instance = Service()
    
    func getCharacters(limit: Int,
                       offset: Int,
                       completionHandler: @escaping HandleCharactersResponse) {
        let urlRequest = Deal.instance.getCharactersUrl(limit: limit, offset: offset)
        AF.request(urlRequest)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    do {
                        if let data = response.data {
                            let decoder = JSONDecoder()
                            let marvelServiceResponse = try decoder.decode(MarvelServiceResponse.self, from: data)
                            completionHandler(marvelServiceResponse, nil)
                        }
                    } catch let error {
                        completionHandler(nil, Text.Error.description + error.localizedDescription)
                    }
                case .failure(let error):
                    completionHandler(nil, error.localizedDescription)
                }
        }
    }
    
}
