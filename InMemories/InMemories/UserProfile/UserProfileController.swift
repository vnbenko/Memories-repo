import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var user: User?
    var userId: String?
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        
        setupLogOutButton()
        fetchUser()
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
    

    
    //MARK: - Fetch user
    fileprivate func fetchUser() {
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        
        Database.fetchUserWithUID(uid: uid) { user in
            self.user = user
            self.navigationItem.title = self.user?.username
            
            self.collectionView.reloadData()
            
            self.fetchOrderedPost()
        }
    }
    
    //MARK: - Fetch posts
    fileprivate func fetchOrderedPost() {
        guard let uid = self.user?.uid else { return }
        
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("posts")
            .child(uid)
            .queryOrdered(byChild: "creationDate")
            .observe(.childAdded) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                guard let user = self.user else { return }
                let post = Post(user: user, dictionary: dictionary)
                self.posts.insert(post, at: 0)
                
                self.collectionView.reloadData()
                
            } withCancel: { error in
                print("Failed to fetch ordered posts: ", error)
            }
    }
    
    //MARK: - Profile header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as? UserProfileHeader else { return UICollectionReusableView() }
        header.user = self.user
        return header
    }
    
    //MARK: - Grid cell
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? UserProfilePhotoCell else { return UICollectionViewCell() }
        
        cell.post = posts[indexPath.item]
        return cell
    }
}

extension UserProfileController: UICollectionViewDelegateFlowLayout {
    //MARK: - Header sizing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    //MARK: - Grid cell sizing
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
    
}
