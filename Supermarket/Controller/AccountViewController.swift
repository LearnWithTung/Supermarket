//
//  AccountViewController.swift
//  Supermarket
//
//  Created by ThangLai on 31/12/2 Reiwa.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    @IBOutlet weak var logOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.logOutButton.layer.borderWidth = 1.0
        self.logOutButton.layer.cornerRadius = 10
        self.logOutButton.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.8745098039, blue: 0.3176470588, alpha: 1)
        
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
