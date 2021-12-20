import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    let homePostCellId = "homePostCellId"
    
    var user: User?
    var posts = [Post]()
    var userId: String?
    var isGridView = true
    var isFinishedPaging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        fetchUser()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updatePosts),
            name: SharePhotoController.updateFeedNotificationName,
            object: nil)
        
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc private func fetchUser() {
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        
        Database.fetchUserWithUID(uid: uid) { [weak self] user in
            guard let self = self else { return }
            
            self.user = user
            self.navigationItem.title = self.user?.username
            
            self.collectionView.reloadData()
            
            self.paginatePost()
        }
    }
    
    @objc private func updatePosts() {
        posts.removeAll()
        fetchOrderedPost()
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logOutAlert = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            
            do {
                try Auth.auth().signOut()
                let signInVC = SignInController()
                let navController = UINavigationController(rootViewController: signInVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            } catch let error {
                self.alert(message: error.localizedDescription, title: "Failed")
            }
        }
        
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(logOutAlert)
        alertController.addAction(cancelAlert)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    private func paginatePost() {
        guard let uid = self.user?.uid else { return }
        
        let reference = Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("posts")
            .child(uid)
        
        var query = reference.queryOrdered(byChild: "creationDate")
        
        if posts.count > 0 {
            let value = posts.last?.creationDate.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            guard var allObject = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObject.reverse()
            if allObject.count < 4 {
                self.isFinishedPaging = true
            }
            
            if self.posts.count > 0 && allObject.count > 0 {
                allObject.removeFirst()
            }
 
            allObject.forEach({ snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let user = self.user else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                self.posts.append(post)
            })
            
            self.collectionView.reloadData()
            
        } withCancel: { error in
            self.alert(message: error.localizedDescription, title: "Failed")
        }
    }
    
    private func fetchOrderedPost() {
        guard let uid = self.user?.uid else { return }
        
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("posts")
            .child(uid)
            .queryOrdered(byChild: "creationDate")
            .observe(.childAdded) { [weak self] snapshot in
                guard let self = self else { return }
                
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                guard let user = self.user else { return }
                let post = Post(user: user, dictionary: dictionary)
                self.posts.insert(post, at: 0)
                
                self.collectionView.reloadData()
                
            } withCancel: { error in
                self.alert(message: error.localizedDescription, title: "Failed")
            }
    }
    
    // MARK: - Configure
    
    private func configure() {
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: homePostCellId)
    }
    
    private func configureUI() {
        configureLogOutButton()
    }
    
    private func configureLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    // MARK: - Profile header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as? UserProfileHeader else { return UICollectionReusableView() }
        header.user = self.user
        header.delegate = self
        
        return header
    }
    
    // MARK: - Grid cell settings
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == self.posts.count - 1 && !isFinishedPaging{
            paginatePost()
        }
        
        if isGridView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? UserProfilePhotoCell else { return UICollectionViewCell() }
            cell.post = posts[indexPath.item]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as? HomeCell else { return UICollectionViewCell() }
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    
}

extension UserProfileController: UICollectionViewDelegateFlowLayout {
   
    // MARK: Header sizing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    // MARK: Grid cell sizing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isGridView {
            let side = (view.frame.width - 2) / 3
            return CGSize(width: side, height: side)
        } else {
            var height: CGFloat = 40 + 8 + 8 // username userprofileimageview
            height += view.frame.width
            height += 50
            height += 60
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

// MARK: - Delegate actions

extension UserProfileController: UserProfileHeaderDelegate {
    func didChangeToListView() {
        isGridView = false
        collectionView.reloadData()
    }
    
    func didChangeToGridView() {
        isGridView = true
        collectionView.reloadData()
    }
    
    
}
