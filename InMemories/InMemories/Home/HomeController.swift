import UIKit
import Firebase

class HomeController: UICollectionViewController {
    
    let cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        setupNavigationItems()
        
        fetchAllPosts()
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("following")
            .child(uid)
            .observeSingleEvent(of: .value) { snapshot in
                guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
                userIdsDictionary.forEach { key, value in
                    Database.fetchUserWithUID(uid: key) { user in
                        self.fetchPostsWithUser(user: user)
                    }
                }
            } withCancel: { error in
                print("Failed to fetch following user ids: ", error)
            }
    }
    
    func setupNavigationItems() {
        let image = #imageLiteral(resourceName: "logo2")
        navigationItem.titleView = UIImageView(image: image)
        
        let camera = #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: camera, style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera() {
        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        present(cameraController, animated: true, completion: nil)
    }
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { user in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("posts")
            .child(user.uid)
            .observeSingleEvent(of: .value) { snapshot in
                
                self.collectionView.refreshControl?.endRefreshing()
                
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                
                dictionaries.forEach { (key: String, value: Any) in
                    guard let dictionary = value as? [String: Any] else { return }
                    
                    var post = Post(user: user, dictionary: dictionary)
                    post.id = key
                    self.posts.append(post)
                }
                
                self.posts.sort { post1, post2 in
                    return post1.creationDate.compare(post2.creationDate) == .orderedDescending
                }
                
                self.collectionView.reloadData()
                
            } withCancel: { error in
                print("Failed to fetch posts: ", error)
            }
    }
    
    
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }
        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8 // username userprofileimageview
        height += view.frame.width
        height += 50
        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
}

extension HomeController: HomePostCellDelegate {
    func didTapCommentButton(post: Post) {
         let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    
}
