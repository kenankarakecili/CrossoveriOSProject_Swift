//
//  LoginVC.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import UIKit

class AuthVC: BaseVC {
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  @IBAction func loginButtonAction(sender: UIButton?) {
    if !checkFields() { return }
    let authItem = AuthStruct(email: emailField.text!,
                              password: passwordField.text!)
    showLoading(true)
    LoginAPI.requestAuth(authItem) { (succeed, token) in
      showLoading(false)
      if succeed {
        User.persistToken(token)
        showMessageWithCompletion("Login is successful.") { () in
          setRootViewController("MapNCID")
        }
      }
    }
  }
  
  func checkFields() -> Bool {
    view.endEditing(true)
    if emailField.isEmpty() {
      showMessageWithCompletion("Please enter your e-mail address.") { () in
        self.emailField.becomeFirstResponder()
      }
      return false
    } else if !isValidEmail(emailField.text!) {
      showMessageWithCompletion("Please enter a valid e-mail address.") { () in
        self.emailField.becomeFirstResponder()
      }
      return false
    } else if passwordField.isEmpty() {
      showMessageWithCompletion("Please enter your password.") { () in
        self.passwordField.becomeFirstResponder()
      }
      return false
    }
    return true
  }
  
}

extension AuthVC: UITextFieldDelegate {
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    let newLength = text.characters.count + string.characters.count - range.length
    if textField === emailField {
      return newLength <= 128
    } else if textField === passwordField {
      return newLength <= 32
    }
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField === emailField {
      passwordField.becomeFirstResponder()
    } else { // passwordField
      loginButtonAction(nil)
    }
    return false
  }
  
}
