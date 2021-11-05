import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navVC = UINavigationController(rootViewController: photoSelectorController)
            navVC.navigationBar.backgroundColor = .white
            present(navVC, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
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
        
        setupViewControllers()
    }
    
    func setupViewControllers() {
        //home
        let homeNavVC = templateNavController(selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //search
        let searchNavVC = templateNavController(selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"))
        
        //plus
        let plusNavVC = templateNavController(selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        //like
        let likeVC = templateNavController(selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"))
        
        //user profile//
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userNavVC = UINavigationController(rootViewController: userProfileController )
        userNavVC.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userNavVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        
        viewControllers = [homeNavVC,
                           searchNavVC,
                           plusNavVC,
                           likeVC,
                           userNavVC]
        
        //modify tab bar
        tabBar.tintColor = .black
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navVC = UINavigationController(rootViewController: viewController)
        viewController.tabBarItem.image = unselectedImage
        viewController.tabBarItem.selectedImage = selectedImage
        return navVC
    }
}
