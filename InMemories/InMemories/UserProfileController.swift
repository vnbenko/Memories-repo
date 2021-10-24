//
//  UserProfileController.swift
//  InMemories
//
//  Created by Meraki on 24.10.2021.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        fetchUser()
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database(url: Constants.shared.urlString).reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let username = dictionary["username"] as? String
            self.navigationItem.title = username
            
        } withCancel: { error in
            print("Failed to fetch user: ", error)
        }


    }
}
