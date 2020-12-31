//
//  RegisterViewController.swift
//  Supermarket
//
//  Created by ThangLai on 30/12/2 Reiwa.
//

import UIKit
import Firebase

class RegisterViewController: BaseViewController {
    
    
    @IBOutlet weak var userNameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var btnAvatar: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        passwordTextField.isSecureTextEntry = true
//        confirmPasswordTextField.isSecureTextEntry = true
        avatarImgView.layer.cornerRadius = avatarImgView.frame.height/2
        avatarImgView.isHidden = true
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func registerAccountPressed(_ sender: Any) {
        checkValidFields()
    }
    
    private func checkValidFields() -> Bool {
        if (userNameTextField.text ?? "").isEmpty || (userNameTextField.text ?? "").isEmpty || (userNameTextField.text ?? "").isEmpty {
            let alert = UIAlertController(title: "Error", message: "Invalid Register", preferredStyle: .alert)
            let successAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            let failAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alert.addAction(successAction)
            alert.addAction(failAction)
            self.present(alert, animated: true, completion: nil)
        }
        if let email = userNameTextField.text, let password = passwordTextField.text, let confpw = confirmPasswordTextField.text {
            if password != confpw {
                let alert = UIAlertController(title: "Error", message: "Password are not matched", preferredStyle: .alert)
                let successAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                let failAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(successAction)
                alert.addAction(failAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    print(err)
                } else {
                    print("data is saved")
                    let alert = UIAlertController(title: "Succesfully", message: "Create account successfully ", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok!!", style: UIAlertAction.Style.default, handler: {_ in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }

        return true
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
//        self.show(vc, sender: self)
        
    }
}

extension RegisterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userNameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.confirmPasswordTextField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func btnAvaterClicked() {
        let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
            
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
//        self.btnAvatar.isHidden = true
        self.btnAvatar.alpha = 1
        self.avatarImgView.isHidden = false
        self.avatarImgView.contentMode = .scaleAspectFill
        self.avatarImgView.image = selectedImage
        self.dismiss(animated: true, completion: nil)
       }


}
