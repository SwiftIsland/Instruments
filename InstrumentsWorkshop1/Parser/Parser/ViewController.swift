//
//  ViewController.swift
//  Parser
//
//  Created by Donny Wals on 04/07/2018.
//  Copyright © 2018 DonnyWals. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let parser = JSONParser()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    parser.load2 {
      let alert = UIAlertController(title: "Done!", message: "JSON was parsed",
                                    preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
    }
  }
}

