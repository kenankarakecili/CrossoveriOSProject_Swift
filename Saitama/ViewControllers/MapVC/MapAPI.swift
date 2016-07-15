//
//  MapAPI.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import Foundation

class MapAPI {
  
  class func requestPlaces(completion: [PlaceStruct] -> Void) {
    let urlString = BaseURL + PlacesEndpoint
    ConnectionHandler.requestGetConnection(urlString) { (responseJson, status, message) in
      let results = unwrapArray(responseJson?["results"] as? [[String: AnyObject]])
      var itemsToReturn: [PlaceStruct] = []
      for result in results {
        let location = unwrapDictionary(result["location"])
        let item = PlaceStruct(id: unwrapString(result["id"]),
                               name: unwrapString(result["name"]),
                               latitude: unwrapString(location["lat"]),
                               longitude: unwrapString(location["lng"]))
        itemsToReturn.append(item)
      }
      completion(itemsToReturn)
    }
  }
  
}
