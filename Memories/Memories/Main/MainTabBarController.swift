import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        showAllControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
    }
    
    // MARK: - Functions
    
    func showAllControllers() {
        //home
        let homeFlowLayout = UICollectionViewFlowLayout()
        let homeController = HomeController(collectionViewLayout: homeFlowLayout)
        let homeNavController = createNavController(rootViewController: homeController, selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"))
        
        //search
        let searchFlowLayout = UICollectionViewFlowLayout()
        let searchController = SearchController(collectionViewLayout: searchFlowLayout)
        let searchNavController = createNavController(rootViewController: searchController, selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"))
        
        //plus
        let plusNavController = createNavController(selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        //like
        let likeFlowLayout = UICollectionViewFlowLayout()
        let likeController = LikeController(collectionViewLayout: likeFlowLayout)
        let likeNavController = createNavController(rootViewController: likeController, selectedImage: #imageLiteral(resourceName: "like_selected_black"), unselectedImage: #imageLiteral(resourceName: "like_unselected"))
        
        //user profile
        let userProfileFlowLayout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: userProfileFlowLayout)
        let userProfileNavController = createNavController(rootViewController: userProfileController, selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"))
        
        viewControllers = [homeNavController,
                           searchNavController,
                           plusNavController,
                           likeNavController,
                           userProfileNavController]
    }
    
    
    
    private func createNavController(rootViewController: UIViewController = UIViewController(), selectedImage: UIImage, unselectedImage: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.image = unselectedImage
        return navController
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        configureTabBar()
    }
    
    private func configureTabBar() {
        tabBar.tintColor = .black
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
}

// MARK: - TabBarController delegate

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            let photoSelectorFlowLayout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: photoSelectorFlowLayout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            navController.navigationBar.backgroundColor = .customGray()
            present(navController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}
