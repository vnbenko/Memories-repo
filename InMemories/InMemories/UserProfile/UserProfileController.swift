import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        fetchUser()
        
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        
        setupLogOutButton()
        
        //fetchPosts()
        
        fetchOrderedPost()
    }
    
    var posts = [Post]()
    
    fileprivate func fetchOrderedPost() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database(url: Constants.shared.databaseUrlString).reference().child("post_images").child(uid)
        
        ref.queryOrdered(byChild: "CreationDate").observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
          
            let post = Post(dictionary: dictionary)
            self.posts.append(post)
            
            self.collectionView.reloadData()
        } withCancel: { error in
            print("Failed to fetch ordered posts: ", error)
        }
        
        
    }
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database(url: Constants.shared.databaseUrlString).reference().child("post_images").child(uid)
        ref.observe(.value) { snapshot in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { (key: String, value: Any) in
                //print("Key: \(key)\nValue: \(value)")
                guard let dictionary = value as? [String: Any] else { return }
                
                let post = Post(dictionary: dictionary)
                self.posts.append(post)
                
            }
            
            self.collectionView.reloadData()
            
        } withCancel: { error in
            print("Failed to fetch post ", error)
        }
        
    }
    
    //MARK: - Profile header settings
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as? UserProfileHeader else { return UICollectionReusableView() }
        header.user = self.user
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    //MARK: - Grid cell settings
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? UserProfilePhotoCell else { return UICollectionViewCell() }
        
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (view.frame.width - 2) / 3
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //MARK: - Fetch user
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("users")
            .child(uid)
            .observeSingleEvent(of: .value) { snapshot in
                
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                self.user = User(dictionary: dictionary)
                self.navigationItem.title = self.user?.userName
                
                self.collectionView.reloadData()
                
            } withCancel: { error in
                print("Failed to fetch user: ", error)
            }
        
    }
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logOutAlert = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            
            do {
                try Auth.auth().signOut()
                let loginVC = LoginController()
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated: true, completion: nil)
            } catch let error {
                print("Failed to sign out: ", error)
            }
        }
        
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(logOutAlert)
        alertController.addAction(cancelAlert)
        
        present(alertController, animated: true, completion: nil)
    }
}
