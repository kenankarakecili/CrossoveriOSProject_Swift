//
//  Request.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import Foundation

enum MethodType: String {
  case POST
  case GET
}

class Request: NSMutableURLRequest {
  
  convenience init(urlString: String, body: [String: AnyObject], methodType: MethodType) {
    self.init()
    timeoutInterval = 60
    HTTPMethod = methodType.rawValue
    URL = NSURL(string: urlString)
    addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    addValue(User.getPersistentToken(), forHTTPHeaderField: "Authorization")
    print("Headers:\(allHTTPHeaderFields!)")
    if methodType == .POST {
      let tempBody: NSMutableDictionary = NSMutableDictionary(dictionary: body)
      HTTPBody = dataFromObject(tempBody)
      print("Request: \(NSString(data: HTTPBody!, encoding: NSUTF8StringEncoding)!)")
    }
  }
  
  func dataFromObject(object: AnyObject) -> NSData {
    return try! NSJSONSerialization.dataWithJSONObject(object, options: .PrettyPrinted)
  }
  
}
