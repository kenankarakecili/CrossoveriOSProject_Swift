//
//  User.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import Foundation

private let kIsFirstLaunchDefaults = "kIsFirstLaunchDefaults"
private let kUserTokenDefaults = "kUserTokenDefaults"

struct AuthStruct {
  let email: String
  let password: String
}

class User {
  
  class func persistToken(token: String) {
    Lockbox().setString(token, forKey: kUserTokenDefaults)
  }
  
  class func getPersistentToken() -> String {
    let token = Lockbox().stringForKey(kUserTokenDefaults)
    return unwrapString(token)
  }
  
  class func isLogin() -> Bool {
    let token = getPersistentToken()
    return !token.isEmpty
  }
  
  class func deleteToken() {
    Lockbox().setString("", forKey: kUserTokenDefaults)
  }
  
  class func persistAppLaunch() {
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: kIsFirstLaunchDefaults)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  class func isAppLaunched() -> Bool {
    return NSUserDefaults.standardUserDefaults().boolForKey(kIsFirstLaunchDefaults)
  }
  
}
