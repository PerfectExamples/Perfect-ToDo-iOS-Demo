//
//  ViewController.swift
//  Perfect-ToDo-iOS
//
//  Created by Ryan Collins on 1/14/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        DataService.instance.load()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }

}
