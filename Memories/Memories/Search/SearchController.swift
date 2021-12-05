import UIKit
import Firebase

class SearchController: UICollectionViewController {
    
    let cellId = "cellId"
    
    //lazy var is used when we need to subscribe on delegate.
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter search text"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .customGray()
        searchBar.delegate = self
        return searchBar
    }()
    
    var users = [User]()
    var filteredUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        navigationController?.navigationBar.addSubview(searchBar)
        
        let navBar = navigationController?.navigationBar
        searchBar.anchor(
            top: navBar?.topAnchor, paddingTop: 0,
            left: navBar?.leftAnchor, paddingLeft: 8,
            right: navBar?.rightAnchor, paddingRight: 8,
            bottom: navBar?.bottomAnchor, paddingBottom: 0,
            width: 0, height: 0)
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.isHidden = false
    }
    
    private func fetchUsers() {
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("users")
            .observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else { return }
                
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                
                dictionaries.forEach { key, value in
                    
                    //check to exclude current user
                    if key == Auth.auth().currentUser?.uid {
                        return
                    }
                    
                    guard let userDictionary = value as? [String: Any] else { return }
                    
                    let user = User(uid: key, dictionary: userDictionary)
                    self.users.append(user)
                }
                
                self.users.sort { user1, user2 in
                    return user1.username.compare(user2.username) == .orderedAscending
                }
                
                self.filteredUsers = self.users
                self.collectionView.reloadData()
            } withCancel: { error in
                print("Failed to fetch users for search: ", error)
            }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let user = filteredUsers[indexPath.item]
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    
}

extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { user in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        
        self.collectionView.reloadData()
    }
}
