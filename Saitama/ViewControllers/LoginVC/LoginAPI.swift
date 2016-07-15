//
//  LoginAPI.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import Foundation

class LoginAPI {
  
  class func requestAuth(authItem: AuthStruct, completion: (succeed: Bool, token: String) -> Void) {
    let urlString = BaseURL + AuthEndpoint
    let body = [
      "email":    authItem.email,
      "password": authItem.password
    ]
    ConnectionHandler.requestPostConnection(urlString , body: body) { (responseJson, status, message) in
      let token = unwrapString(responseJson?["accessToken"])
      completion(succeed: status == .SUCCESSFUL, token: token)
    }
  }
  
  class func requestRegister(authItem: AuthStruct, completion: (succeed: Bool, token: String) -> Void) {
    let urlString = BaseURL + RegisterEndpoint
    let body = [
      "email":    authItem.email,
      "password": authItem.password
    ]
    ConnectionHandler.requestPostConnection(urlString , body: body) { (responseJson, status, message) in
      let token = unwrapString(responseJson?["accessToken"])
      completion(succeed: status == .SUCCESSFUL, token: token)
    }
  }
  
}
