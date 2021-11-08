import UIKit
import Firebase

class HomeController: UICollectionViewController {
    
    let cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItems()
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
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                
                dictionaries.forEach { (key: String, value: Any) in
                    guard let dictionary = value as? [String: Any] else { return }
                    
                    let post = Post(user: user, dictionary: dictionary)
                    
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
