//
//  MarkerView.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import UIKit

class MarkerView: UIView {
  
  @IBOutlet weak var titleLabel: UILabel!
  
  class func instanceFromNib() -> MarkerView {
    return UINib(nibName: "MarkerView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! MarkerView
  }
  
  func setup(title: String) {
    titleLabel.text = title
  }
  
}
