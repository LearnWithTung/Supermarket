//
//  StartViewController.swift
//  Supermarket
//
//  Created by ThangLai on 30/12/2 Reiwa.
//

import UIKit

class StartViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "icons8-reply-arrow-48 1")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    @IBAction func registerPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class BaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "icons8-reply-arrow-48 1")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "icons8-reply-arrow-48 1")
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.05098039216, blue: 0.05098039216, alpha: 1)          //0D0D0D
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-reply-arrow-48 1"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton

    }
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
