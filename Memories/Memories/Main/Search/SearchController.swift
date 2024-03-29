import UIKit
import Firebase

class SearchController: UICollectionViewController {
    
    
    
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
    
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.cellId)
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
    
    // MARK: - Functions
    
    private func fetchUsers() {
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("users")
            .observeSingleEvent(of: .value) { snapshot in
               
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
                
                self.users.sort { $0.username > $1.username }

                self.filteredUsers = self.users
                self.collectionView.reloadData()
            } withCancel: { error in
                self.alert(message: error.localizedDescription, title: "Failed")
            }
        
    }
    
    // MARK: - Grid cell settings
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.cellId, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
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

// MARK: - Grid cell sizing

extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 66)
        return size
    }
}

// MARK: - SearchBar Delegate

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
