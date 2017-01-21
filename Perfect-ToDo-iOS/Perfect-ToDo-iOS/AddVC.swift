//
//  AddVC.swift
//  Perfect-ToDo-iOS
//
//  Created by Ryan Collins on 1/18/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import UIKit

class AddVC: UIViewController {

    @IBOutlet weak var itemField: UITextField!
    @IBOutlet weak var dueDateSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dueDateSwitchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.cancel(_:)), name: .addSuccessful, object: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func setStateRunning() {
        itemField.isHidden = true
        dueDateSwitch.isHidden = true
        datePicker.isHidden = true
        warningLabel.isHidden = true
        activityIndicator.isHidden = false
        dueDateSwitchLabel.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func setStateStopped() {
        itemField.isHidden = false
        dueDateSwitch.isHidden = false
        activityIndicator.isHidden = true
        dueDateSwitchLabel.isHidden = false
        activityIndicator.stopAnimating()
        if dueDateSwitch.isOn {
            datePicker.isHidden = false
        }
    }
    
    func setStateWarning(withMessage message: String) {
        setStateStopped()
        warningLabel.isHidden = false
        warningLabel.text? = message
    }

    @IBAction func dueDateSwitchPressed(_ sender: UISwitch) {
        if sender.isOn {
            datePicker.isHidden = false
        } else {
            datePicker.isHidden = true
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        DispatchQueue.main.async {
            self.setStateStopped()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func add(_ sender: Any) {
        setStateRunning()
        if let item = itemField.text {
            guard item != "" else {
                setStateWarning(withMessage: "Item is required")
                return
            }
            
            var date: Date? = nil
            
            if dueDateSwitch.isOn {
                date = datePicker.date
            }
            
            DataService.instance.add(withItemName: item, withDueDate: date)
        }
    }
}
