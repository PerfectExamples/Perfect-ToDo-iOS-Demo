//
//  RegisterVC.swift
//  Perfect-ToDo-iOS
//
//  Created by Ryan Collins on 1/18/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordVerificationField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.spellCheckingType = .no
        NotificationCenter.default.addObserver(self, selector: #selector(self.setStateUsernameTaken), name: .usernameTaken, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setRegistrationFailure), name: .userRegistrationFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.registeredOkay), name: .userRegistered, object: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func setStateRegistering() {
        registerButton.isHidden = true
        warningLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func setStateStopped() {
        registerButton.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func setStateFailure(withWarning warning: String) {
        setStateStopped()
        warningLabel.isHidden = false
        warningLabel.text? = warning
    }
    
    func setStateUsernameTaken() {
        DispatchQueue.main.async {
            self.setStateFailure(withWarning: "Username Taken")
        }
    }
    
    func setRegistrationFailure() {
        DispatchQueue.main.async {
            self.setStateFailure(withWarning: "Registration Failure")
        }
    }
    
    func registeredOkay() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(Notification(name: .registrationSuccess))
        }
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: Any) {
        setStateRegistering()
        if let password = passwordField.text, let verification = passwordVerificationField.text, let username = emailField.text {
            guard password == verification else {
                self.setStateFailure(withWarning: "Passwords Don't Match")
                return
            }
            
            let user = RemoteUser(user: username, pass: password)
            user.register()
        } else {
            self.setStateFailure(withWarning: "All Fields are Required")
        }
        
    }
}
