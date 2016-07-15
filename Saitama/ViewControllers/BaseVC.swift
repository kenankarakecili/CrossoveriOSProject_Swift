//
//  BaseVC.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.translucent = false
    navigationController?.navigationBar.barTintColor = clrBlue
    navigationController?.navigationBar.barStyle = UIBarStyle.Default
    let backButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = backButton
  }
  
}
