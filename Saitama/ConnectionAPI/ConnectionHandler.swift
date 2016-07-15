//
//  ConnectionHandler.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import UIKit

enum ResponseStatus: String {
  case FAILED
  case SUCCESSFUL
}

func unwrapString(str: AnyObject?) -> String {
  if let myStr = str {
    return String(myStr)
  }
  return ""
}

func unwrapArray(array: [AnyObject]?) -> [AnyObject] {
  if let myArray = array {
    return myArray
  }
  return []
}

func unwrapDictionary(dic: AnyObject?) -> [String: AnyObject] {
  if let myDic = dic as? [String: AnyObject] {
    return myDic
  }
  return [:]
}

class ConnectionHandler {
  
  typealias ConnectionCompletion = (responseData: NSData?) -> Void
  typealias ParsingCompletion = (parsedJson: [String: AnyObject]?) -> Void
  typealias ResultJsonCompletion = (responseJson: [String: AnyObject]?, status: ResponseStatus, message: String) -> Void
  
  class func requestGetConnection(urlString: String, completion: ResultJsonCompletion) {
    let request = Request(urlString: urlString, body: [:], methodType: .GET)
    startConnection(request) { (responseData) in
      startParsingData(responseData) { (parsedJson) in
        let status = self.handleStatus(parsedJson)
        let message = unwrapString(parsedJson?["message"])
        completion(responseJson: parsedJson, status: status, message: message)
      }
    }
  }
  
  class func requestPostConnection(urlString: String, body: [String: AnyObject], completion: ResultJsonCompletion) {
    let request = Request(urlString: urlString, body: body, methodType: .POST)
    startConnection(request) { (responseData) in
      startParsingData(responseData) { (parsedJson) in
        let status = self.handleStatus(parsedJson)
        let message = unwrapString(parsedJson?["message"])
        completion(responseJson: parsedJson, status: status, message: message)
      }
    }
  }
  
  private class func startConnection(request: NSURLRequest, completion: ConnectionCompletion) {
    if !isReachable() {
      showMessageOnly(msgNetworkError)
      completion(responseData: nil)
      return
    }
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    configuration.requestCachePolicy = .ReloadIgnoringLocalAndRemoteCacheData
    let session = NSURLSession(configuration: configuration)
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      if error != nil || data == nil {
//        print("Nil data. Error: \(error!.localizedDescription)")
        completion(responseData: nil)
        return
      }
      completion(responseData: data)
    }
    task.resume()
  }
  
  private class func startParsingData(data: NSData?, completion: ParsingCompletion) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      if let myData = data {
        do {
//          print("Response: \(NSString(data: myData, encoding: NSUTF8StringEncoding)!)")
          let json = try NSJSONSerialization.JSONObjectWithData(myData, options: NSJSONReadingOptions())
          dispatch_async(dispatch_get_main_queue()) {
            completion(parsedJson: json as? [String : AnyObject])
          }
        } catch {
          dispatch_async(dispatch_get_main_queue()) {
            completion(parsedJson: nil)
          }
        }
      } else {
        dispatch_async(dispatch_get_main_queue()) {
          completion(parsedJson: nil)
        }
      }
    }
  }
  
  class func handleStatus(json: [String: AnyObject]?) -> ResponseStatus {
    guard let myJson = json else {
      showMessageOnly(msgNoResponseError)
      return .FAILED
    }
    let message = unwrapString(myJson["message"])
    let code = unwrapString(myJson["code"])
    if code.isEmpty == false {
      if code == "0001C" { // invalid access token
        showMessageWithCompletion(message) { () in
          setRootViewController("AuthVCID")
        }
      } else {
        showMessageOnly(message)
      }
      return .FAILED
    }
    return .SUCCESSFUL
  }
  
}
