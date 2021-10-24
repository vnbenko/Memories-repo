//
//  MainTabBarController.swift
//  InMemories
//
//  Created by Meraki on 24.10.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navVC = UINavigationController(rootViewController: userProfileController )
        
        navVC.tabBarItem.image = UIImage(named: "profile_unselected")
        navVC.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        tabBar.tintColor = .black
        
        viewControllers = [navVC, UIViewController()]
    }
}
