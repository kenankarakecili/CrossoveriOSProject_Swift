//
//  Utilities.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import UIKit

func isReachable() -> Bool {
  let reachability = Reachability.reachabilityForInternetConnection()
  let networkStatus = reachability.currentReachabilityStatus()
  return networkStatus != NotReachable
}

func showLoading(show: Bool) {
  guard let window = UIApplication.sharedApplication().keyWindow else { return }
  var activityIndicator = window.viewWithTag(123) as! UIActivityIndicatorView?
  if activityIndicator == nil {
    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    activityIndicator!.tag = 123
    activityIndicator!.center = window.center
    activityIndicator!.startAnimating()
    window.addSubview(activityIndicator!)
  }
  window.bringSubviewToFront(activityIndicator!)
  dispatch_async(dispatch_get_main_queue()) {
    UIView.animateWithDuration(0.4, animations: {
      activityIndicator?.alpha = CGFloat(show)
      }, completion: { finished in
        window.userInteractionEnabled = !Bool(show)
    })
  }
}

func showMessageOnly(message: String) {
  showCompleteMessage("", message: message, cancel: false, completion: nil)
}

func showMessageWithCompletion(message: String, completion: Void -> Void) {
  showCompleteMessage("", message: message, cancel: false, completion: completion)
}

func showCompleteMessage(title: String, message: String, cancel: Bool, completion: (Void -> Void)?) {
  if message.characters.count == 0 { return }
  let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
  let action = UIAlertAction(title: "OK", style: .Default) { (alertAction) in
    if let myCompletion = completion {
      myCompletion()
    }
  }
  alert.addAction(action)
  if cancel {
    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
  }
  if (getTopmostVC()?.isKindOfClass(UIAlertController) == false) {
    getTopmostVC()?.presentViewController(alert, animated: true, completion: nil)
  }
}

func getTopmostVC() -> UIViewController? {
  if var topVC = UIApplication.sharedApplication().keyWindow?.rootViewController {
    while let presentedVC = topVC.presentedViewController {
      topVC = presentedVC
    }
    return topVC
  }
  return nil
}

func setRootViewController(vcID: String) {
  dispatch_async(dispatch_get_main_queue()) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginVC = storyboard.instantiateViewControllerWithIdentifier(vcID)
    UIApplication.sharedApplication().delegate?.window!?.rootViewController = loginVC
    UIApplication.sharedApplication().delegate?.window!?.makeKeyAndVisible()
  }
}

func isValidEmail(text: String) -> Bool {
  let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
  let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
  return emailTest.evaluateWithObject(text)
}

// EXTENSIONS
extension UITextField {
  
  func isEmpty() -> Bool {
    return self.text == "" ? true : false
  }
  
  func setupToolbar() {
    let toolBar = UIToolbar()
    toolBar.barStyle = UIBarStyle.Default
    toolBar.tintColor = clrBlue
    toolBar.sizeToFit()
    let doneButton = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(dismissKeyboard))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//    let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(cancelButtonAction))
    toolBar.setItems([spaceButton, doneButton], animated: false)
    inputAccessoryView = toolBar
  }
  
  @objc private func dismissKeyboard() {
    resignFirstResponder()
  }
  
}

class NonPerformField: UITextField {
  
  override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
    return false
  }
  
}
