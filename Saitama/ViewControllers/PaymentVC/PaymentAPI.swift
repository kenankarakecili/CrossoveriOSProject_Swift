//
//  PaymentAPI.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import Foundation

class PaymentAPI {
  
  class func requestPayment(paymentItem: PaymentStruct, completion: (succeed: Bool, message: String) -> Void) {
    let urlString = BaseURL + PaymentEndpoint
    let body = [
      "number":     paymentItem.number,
      "name":       paymentItem.name,
      "expiration": paymentItem.expiration,
      "code":       paymentItem.code
    ]
    ConnectionHandler.requestPostConnection(urlString, body: body) { (responseJson, status, message) in
      completion(succeed: status == .SUCCESSFUL, message: message)
    }
  }
  
}
