import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItems()
        fetchPosts()
    }
    
    func setupNavigationItems() {
        let image = #imageLiteral(resourceName: "logo2")
        navigationItem.titleView = UIImageView(image: image)
        
    }
    
    var posts = [Post]()
    
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 2)
    }
    
    
}
