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
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.spellCheckingType = .no
        activityIndicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadToDos), name: .downloadComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateInvalidLogin), name: .invalidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAPIUnreachable), name: .apiServerUnreachable, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateRegistrationSuccess), name: .registrationSuccess, object: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func updateStateRunning() {
        loginButton.isHidden = true
        loginButton.isEnabled = false
        warningLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func updateStateStopped() {
        loginButton.isHidden = false
        loginButton.isEnabled = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func updateStateError(witMessage message: String) {
        updateStateStopped()
        warningLabel.text = message
        warningLabel.isHidden = false
    }
    
    func updateInvalidLogin() {
        DispatchQueue.main.async {
            // Do UI stuff here
            self.updateStateError(witMessage: "Invalid Login")
        }
    }
    
    func updateAPIUnreachable() {
        DispatchQueue.main.async {
            self.updateStateError(witMessage: "Service Unreachable")
        }
    }
    
    func updateRegistrationSuccess() {
        DispatchQueue.main.async {
            self.updateStateError(witMessage: "Registration Successful")
        }
    }
    
    @IBAction func login(_ sender: Any) {
        
        updateStateRunning()
        
        if emailField.text == nil || emailField.text == "" || passwordField.text == nil || passwordField.text == "" {
            updateStateError(witMessage: "All Fields are Required")
        } else {
            if let email = emailField.text, let pass = passwordField.text {
                DataService.instance.load(forUsername: email, withPassword: pass)
                self.emailField.text? = ""
                self.passwordField.text? = ""
                updateStateStopped()
            }
        }
    }
    
    @objc func loadToDos() {
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let toDoVC = storyBoard.instantiateViewController(withIdentifier: "ToDoVC") as! ToDoVC
            self.present(toDoVC, animated:true, completion:nil)
        }
    }
}
