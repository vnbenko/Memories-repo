import UIKit
import Firebase

final class AppController {
    
    static let shared = AppController()
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppState),
            name: .AuthStateDidChange,
            object: nil)
    }
    
    func configureFirebase() {
        FirebaseApp.configure()
    }
    
    func show(in window: UIWindow?) {
        guard let window = window else { return }
        
        self.window = window
        window.tintColor = .black
        window.backgroundColor = .white
        
        handleAppState()
        
        window.makeKeyAndVisible()
    }
    
    @objc private func handleAppState() {
        if Auth.auth().currentUser != nil {
            let mainTabBarController = MainTabBarController()
            rootViewController = mainTabBarController
        } else {
            rootViewController = SignInController()
        }
    }
}
