import UIKit
import Firebase

class HomeController: UICollectionViewController {
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleUpdateFeed), for: .valueChanged)
        return refreshControl
        
    }()
    
    var posts = [Post]()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotification()
        
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.cellIdentifier)
        
        collectionView.refreshControl = refreshControl
        
        setupNavigationItems()
        
        fetchAllPosts()
    }
    
    // MARK: - Actions
    
    @objc func handleCamera() {
        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        present(cameraController, animated: true, completion: nil)
    }
    
    @objc func handleUpdateFeed() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    // MARK: - Fetch Functions
    
    private func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUsers()
    }
    
    private func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { [weak self] user in
            guard let self = self else { return }
            
            self.fetchPostsWithUser(user: user)
        }
    }
    
    private func fetchFollowingUsers() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("following")
            .child(uid)
            .observeSingleEvent(of: .value) { snapshot in
                
                guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
                userIdsDictionary.forEach { key, value in
                    Database.fetchUserWithUID(uid: key) { [weak self] user in
                        guard let self = self else { return }
                        
                        self.fetchPostsWithUser(user: user)
                    }
                }
            } withCancel: { error in
                self.alert(message: error.localizedDescription, title: "Failed")
            }
    }
    
    private func fetchPostsWithUser(user: User) {
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("posts")
            .child(user.uid)
            .observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else { return }
                
                self.collectionView.refreshControl?.endRefreshing()
                
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                
                dictionaries.forEach { (key: String, value: Any) in
                    guard let dictionary = value as? [String: Any] else { return }
                    
                    var post = Post(user: user, dictionary: dictionary)
                    post.id = key
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    Database.database(url: Constants.shared.databaseUrlString).reference()
                        .child("likes")
                        .child(key)
                        .child(uid)
                        .observeSingleEvent(of: .value) { [weak self] snapshot in
                            guard let self = self else { return }
                            
                            if let value = snapshot.value as? Int, value == 1 {
                                post.isLiked = true
                            } else {
                                post.isLiked = false
                            }
                            self.posts.append(post)
                            
                            self.posts.sort { post1, post2 in
                                return post1.creationDate.compare(post2.creationDate) == .orderedDescending
                            }
                            self.collectionView.reloadData()
                        } withCancel: { error in
                            self.alert(message: error.localizedDescription, title: "Failed")
                        }
                }
                
            } withCancel: { error in
                self.alert(message: error.localizedDescription, title: "Failed")
            }
    }
    
    private func setupNavigationItems() {
        let image = UIImage(named: "bar_logo")?.withRenderingMode(.alwaysOriginal)
        navigationItem.titleView = UIImageView(image: image)
        
        
        let camera = UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: camera, style: .plain, target: self, action: #selector(handleCamera))
    }
    
    private func subscribeToNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUpdateFeed),
            name: SharePhotoController.updateFeedNotificationName,
            object: nil)
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.cellIdentifier, for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height =  view.frame.width + 166 // username userprofileimageview 50 + 8 + 8 + 50 + 60
        return CGSize(width: view.frame.width, height: height)
    }
}

extension HomeController: HomeCellDelegate {
    func didTapCommentButton(post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didTapLikeButton(cell: HomeCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid: post.isLiked == true ? 0 : 1]
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("likes")
            .child(postId)
            .updateChildValues(values) { [weak self] error, _ in
                guard let self = self else { return }
                
                if let error = error {
                    self.alert(message: error.localizedDescription, title: "Failed")
                    return
                }
                
                values[uid] == 1 ? print("Successfully liked post") : print("Successfully unliked post")
                
                post.isLiked = !post.isLiked
                self.posts[indexPath.item] = post
                self.collectionView.reloadItems(at: [indexPath])
            }
    }
    
    
    
    
}