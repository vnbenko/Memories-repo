import UIKit
import Firebase

class ActivityController: UICollectionViewController {
    
    var followers = [Followers]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        fetchUsers()
    }
    
    // MARK: - Fetch Functions
    
    //TODO: - Fetch activity
    private func fetchUsers() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("followers")
            .child(currentUserId)
            .observeSingleEvent(of: .value) { snapshot in
                
                guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
                
                
            }
        
    }
    
    private func configure() {
        collectionView.register(ActivityCell.self, forCellWithReuseIdentifier: ActivityCell.cellId)
        configureNavigationItems()
    }
    
    private func configureNavigationItems() {
        let logoImage = UIImage(named: "bar_logo")?.withRenderingMode(.alwaysOriginal)
        navigationItem.titleView = UIImageView(image: logoImage)
    }
    
    
    // MARK: - Grid cell settings
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCell.cellId, for: indexPath) as? ActivityCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    // MARK: - Grid cell sizing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension ActivityController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 66)
        return size
    }
    
    
    
}
