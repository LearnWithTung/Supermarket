//
//  SignInViewController.swift
//  Supermarket
//
//  Created by ThangLai on 30/12/2 Reiwa.
//

import UIKit
import Firebase

class SignInViewController: BaseViewController {
    
    @IBOutlet weak var userNameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = "1@a.com"
        passwordTextField.text = "123456"
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signInPressed(_ sender: Any) {

        if let email = userNameTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
              guard let _ = self else { return }
                if let err = error {
                    print(err)
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self?.present(alert, animated: true, completion: {
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.dismissAlertController))
                                alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
                    })

                } else {
                    print("login successfully")
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "MainTabBarViewController") as! MainTabBarViewController
                    self?.navigationController?.pushViewController(vc, animated: true)
        
                }

            }

        }


//        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
//        guard let password = UserDefaults.standard.string(forKey: "password") else { return }
//
//        if userNameTextField.text == username && passwordTextField.text == password {
//            let alert = UIAlertController(title: "Login Succesfully", message: nil, preferredStyle: .alert)
//            let successAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(successAction)
//            self.present(alert, animated: true, completion: nil)
//        }
//        else {
//            let alert = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alert.addAction(cancelAction)
//            self.present(alert, animated: true, completion: {
//                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
//                        alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
//            })
//        }
        
    }
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


extension SignInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userNameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        return true
    }


}
