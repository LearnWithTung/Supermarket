//
//  CustomTextField.swift
//  Supermarket
//
//  Created by ThangLai on 30/12/2 Reiwa.
//

import UIKit

class CustomTextField: UITextField {
    required init?(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
        // Add custom code here
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1.5
        self.layer.masksToBounds = true
        self.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        self.textColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    }

}

extension CustomTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
}
