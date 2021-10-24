//
//  MainTabBarController.swift
//  InMemories
//
//  Created by Meraki on 24.10.2021.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                navController.isNavigationBarHidden = true
                
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navVC = UINavigationController(rootViewController: userProfileController )
        
        navVC.tabBarItem.image = UIImage(named: "profile_unselected")
        navVC.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        tabBar.tintColor = .black
        
        viewControllers = [navVC, UIViewController()]
    }
}
