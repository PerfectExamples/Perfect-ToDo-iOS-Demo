//
//  ViewController.swift
//  Perfect-ToDo-iOS
//
//  Created by Ryan Collins on 1/14/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var warningLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        DataService.instance.load()
        activityIndicator.isHidden = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func updateStateRunning() {
        self.warningLabel.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func updateStateStopped() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    func updateStateError(witMessage message: String) {
        updateStateStopped()
        self.warningLabel.text = message
        self.warningLabel.isHidden = false
    }
    
    @IBAction func login(_ sender: Any) {
        
        updateStateRunning()
        
        if emailField.text == nil || emailField.text == "" || passwordField.text == nil || passwordField.text == "" {
            updateStateError(witMessage: "All Fields are Required")
        } else {
            //try login
        }
    }
}
