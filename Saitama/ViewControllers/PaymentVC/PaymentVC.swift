//
//  PaymentVC.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import UIKit

struct PaymentStruct {
  let number: String
  let name: String
  let expiration: String
  let code: String
}

class PaymentVC: BaseVC {
  
  @IBOutlet weak var cardNumberField: UITextField!
  @IBOutlet weak var cardOwnerField: UITextField!
  @IBOutlet weak var monthField: NonPerformField!
  @IBOutlet weak var yearField: NonPerformField!
  @IBOutlet weak var ccvField: UITextField!
  
  let pickerView = KKPickerView()
  var months: [String] = []
  var years: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pickerView.myDelegate = self
    setUI()
    fillMonthsArray()
    fillYearsArray()
  }
  
  func checkFields() -> Bool {
    if cardNumberField.isEmpty() {
      showMessageWithCompletion("Please enter your card number.") { () in
        self.cardNumberField.becomeFirstResponder()
      }
      return false
    } else if cardNumberField.text?.characters.count < 19 {
      showMessageWithCompletion("Please enter a valid card number.") { () in
        self.cardNumberField.becomeFirstResponder()
      }
      return false
    } else if cardOwnerField.isEmpty() {
      showMessageWithCompletion("Please enter your name and lastname.") { () in
        self.cardOwnerField.becomeFirstResponder()
      }
      return false
    } else if monthField.isEmpty() {
      showMessageWithCompletion("Please enter your card's expiration month.") { () in
        self.monthField.becomeFirstResponder()
      }
      return false
    } else if yearField.isEmpty() {
      showMessageWithCompletion("Please enter your card's expiration year.") { () in
        self.yearField.becomeFirstResponder()
      }
      return false
    } else if ccvField.isEmpty() {
      showMessageWithCompletion("Please enter your card's ccv.") { () in
        self.ccvField.becomeFirstResponder()
      }
      return false
    }
    return true
  }
  
  func setUI() {
    cardNumberField.setupToolbar()
    cardOwnerField.setupToolbar()
    ccvField.setupToolbar()
  }
  
  func fillMonthsArray() {
    for month in 1...12 {
      months.append(String(month))
    }
  }
  
  func fillYearsArray() {
    let currentYear = KKDateFormatter.convertDate(NSDate(), fromFormat: "yyyy-MM-dd HH:mm.zzz", toFormat: "yyyy")
    for incrementation in 0...20 {
      let yearToAppend = Int(currentYear)! + incrementation
      years.append(String(yearToAppend))
    }
  }
  
  @IBAction func payButtonAction(sender: UIButton) {
    view.endEditing(true)
    if !checkFields() { return }
    let paymentItem = PaymentStruct(number: cardNumberField.text!,
                                    name: cardOwnerField.text!,
                                    expiration: "\(monthField.text!)/\(yearField.text!)",
                                    code: ccvField.text!)
    PaymentAPI.requestPayment(paymentItem) { (succeed, message) in
      if succeed {
        showMessageWithCompletion(message) { () in
          self.navigationController?.popViewControllerAnimated(true)
        }
      }
    }
  }
  
}

extension PaymentVC: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(textField: UITextField) {
    if textField === monthField {
      pickerView.setup(textField, array: months)
    } else if textField === yearField {
      pickerView.setup(textField, array: years)
    }
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    let newLength = text.characters.count + string.characters.count - range.length
    if textField === cardNumberField {
      let text = textField.text
      if text?.characters.count == 4 || text?.characters.count == 9 || text?.characters.count == 14 {
        textField.text = text! + " " + string
      }
      return newLength <= 19
    } else if textField === ccvField {
      return newLength <= 3
    }
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField === cardOwnerField {
      monthField.becomeFirstResponder()
    }
    return false
  }
  
}

extension PaymentVC: KKPickerViewDelegate {
  
  func pickerDidSelectAction(row: Int) {
    if pickerView.field === monthField {
      monthField.text = months[row]
    } else if pickerView.field === yearField {
      yearField.text = years[row]
    }
  }
  
}
