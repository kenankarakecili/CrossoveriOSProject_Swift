//
//  SignUpVC.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import UIKit

class RegisterVC: BaseVC {
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var password1Field: UITextField!
  @IBOutlet weak var password2Field: UITextField!
  
  @IBAction func backButtonAction(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func signUpButtonAction(sender: UIButton?) {
    if !checkFields() { return }
    let authItem = AuthStruct(email: emailField.text!,
                              password: password1Field.text!)
    showLoading(true)
    LoginAPI.requestRegister(authItem) { (succeed, token) in
      showLoading(false)
      if succeed {
        User.persistToken(token)
        showMessageWithCompletion("Registered successfully.") { () in
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
    } else if password1Field.isEmpty() {
      showMessageWithCompletion("Please enter a password.") { () in
        self.password1Field.becomeFirstResponder()
      }
      return false
    } else if password2Field.isEmpty() {
      showMessageWithCompletion("Please re-enter the password.") { () in
        self.password2Field.becomeFirstResponder()
      }
      return false
    } else if password1Field.text! != password2Field.text! {
      showMessageWithCompletion("Passwords do not match!\nPlease re-enter the password.") { () in
        self.password2Field.text = ""
        self.password2Field.becomeFirstResponder()
      }
      return false
    }
    return true
  }
  
}

extension RegisterVC: UITextFieldDelegate {
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    let newLength = text.characters.count + string.characters.count - range.length
    if textField === emailField {
      return newLength <= 128
    } else if textField === password1Field {
      return newLength <= 32
    } else if textField === password2Field {
      return newLength <= 32
    }
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField === emailField {
      password1Field.becomeFirstResponder()
    } else if textField === password1Field {
      password2Field.becomeFirstResponder()
    } else { // password2Field
      signUpButtonAction(nil)
    }
    return false
  }
  
}
