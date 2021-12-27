import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader: UICollectionViewCell {
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        return imageView
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [
            .font : UIFont.boldSystemFont(ofSize: 14)
        ])
        attributedText.append(NSAttributedString(string: "posts", attributes: [
            .foregroundColor : UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 14)
        ]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [
            .font : UIFont.boldSystemFont(ofSize: 14)
        ])
        attributedText.append(NSAttributedString(string: "followers", attributes: [
            .foregroundColor : UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 14)
        ]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [
            .font : UIFont.boldSystemFont(ofSize: 14)
        ])
        attributedText.append(NSAttributedString(string: "following", attributes: [
            .foregroundColor : UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 14)
        ]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //lazy var?
    let editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        
        button.addTarget(self, action: #selector(handleProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            usernameLabel.text = user?.username
            
            setupEditFollowButton()
            setupActivityLabels()
        }
    }
    
    var delegate: UserProfileHeaderDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setupActivityLabels),
            name: UserProfileController.updateActivityLabelsNotificationName,
            object: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Actions
    
    @objc func handleChangeToListView() {
        listButton.tintColor = .customBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
    }
    
    @objc func handleChangeToGridView() {
        gridButton.tintColor = .customBlue()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
        
    }
    
    @objc func handleProfileOrFollow() {
        guard let currentLoggedInId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInId == userId {
            print("tap edit profile")
            
        } else {
            if editProfileFollowButton.titleLabel?.text == "Unfollow" {
                Database.database(url: Constants.shared.databaseUrlString).reference()
                    .child("following")
                    .child(currentLoggedInId)
                    .child(userId)
                    .removeValue { error, reference in
                        
                        if let error = error {
                            print("Failed to unfollow user: ", error)
                            return
                        }
                        
                        print("Successfully unfollowed user: ", self.user?.username ?? "")
                        
                        self.setupFollowStyle()
                        self.setupFollowingLabels()
                    }
                
                Database.database(url: Constants.shared.databaseUrlString).reference()
                    .child("followers")
                    .child(userId)
                    .child(currentLoggedInId)
                    .removeValue { error, reference in
                        
                        if let error = error {
                            print("Failed to unfollow user: ", error)
                            return
                        }
                        
                        self.setupFollowersLabels()
                    }
                
            } else {
                
                let values = [userId: Date().timeIntervalSince1970]
                Database.database(url: Constants.shared.databaseUrlString).reference()
                    .child("following")
                    .child(currentLoggedInId)
                    .updateChildValues(values) { error, reference in
                        
                        if let error = error {
                            print("Failed to follow user: ", error)
                            return
                        }
                        
                        print("Successfully followed user: ", self.user?.username ?? "")
                        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                        self.editProfileFollowButton.backgroundColor = .white
                        self.editProfileFollowButton.setTitleColor(.black, for: .normal)
                        self.setupFollowingLabels()
                    }
                
                Database.database(url: Constants.shared.databaseUrlString).reference()
                    .child("followers")
                    .child(userId)
                    .child(currentLoggedInId)
                    .updateChildValues(values) { error, reference in
                        
                        if let error = error {
                            print("Failed to follow user: ", error)
                            return
                        }
                        self.setupFollowersLabels()
                    }
            }
        }
    }
    
    // MARK: - Functions
    
    private func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .customBlue()
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupEditFollowButton() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid,
              let userId = user?.uid else { return }
        
        if currentLoggedInUserId != userId {
            //check if following
            Database.database(url: Constants.shared.databaseUrlString).reference()
                .child("following")
                .child(currentLoggedInUserId)
                .child(userId)
                .observeSingleEvent(of: .value) { snapshot in
                    
                    if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                    } else {
                        self.setupFollowStyle()
                        
                    }
                    
                } withCancel: { error in
                    print("Failed to check if following: ", error)
                }
        }
    }
    
    @objc private func setupActivityLabels() {
        setupPostsLabel()
        setupFollowersLabels()
        setupFollowingLabels()
    }
    
    private func setupPostsLabel() {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let userId = user?.uid else { return }
        
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("posts")
            .child(currentUserId == userId ? currentUserId : userId)
            .observeSingleEvent(of: .value) { snapshot in
                guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
                let attributedText = NSMutableAttributedString(string: "\(userIdsDictionary.count)\n", attributes: [
                    .font : UIFont.boldSystemFont(ofSize: 14)
                ])
                attributedText.append(NSAttributedString(string: "posts", attributes: [
                    .foregroundColor : UIColor.lightGray,
                    .font: UIFont.systemFont(ofSize: 14)
                ]))
                self.postsLabel.attributedText = attributedText
            }
    }
    
    private func setupFollowersLabels() {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let userId = user?.uid else { return }
        
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("followers")
            .child(currentUserId == userId ? currentUserId : userId)
            .observeSingleEvent(of: .value) { snapshot in
                let userIdsDictionary = snapshot.value as? [String: Any]
                
                let attributedText = NSMutableAttributedString(string: "\(userIdsDictionary?.count ?? 0)\n", attributes: [
                    .font : UIFont.boldSystemFont(ofSize: 14)
                ])
                attributedText.append(NSAttributedString(string: "followers", attributes: [
                    .foregroundColor : UIColor.lightGray,
                    .font: UIFont.systemFont(ofSize: 14)
                ]))
                self.followersLabel.attributedText = attributedText
            }
    }
    
    private func setupFollowingLabels() {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let userId = user?.uid else { return }
        
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("following")
            .child(currentUserId == userId ? currentUserId : userId)
            .observeSingleEvent(of: .value) { snapshot in
                guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
                let attributedText = NSMutableAttributedString(string: "\(userIdsDictionary.count)\n", attributes: [
                    .font : UIFont.boldSystemFont(ofSize: 14)
                ])
                attributedText.append(NSAttributedString(string: "following", attributes: [
                    .foregroundColor : UIColor.lightGray,
                    .font: UIFont.systemFont(ofSize: 14)
                ]))
                self.followingLabel.attributedText = attributedText
            }
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        configureButtonToolbar()
        configureProfileUI()
    }
    
    private func configureProfileUI() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(editProfileFollowButton)
        
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        profileImageView.anchor(
            top: topAnchor, paddingTop: 12,
            left: leftAnchor, paddingLeft: 12,
            right: nil, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 80, height: 80
        )
        
        // MARK: User stats
        let stackView = UIStackView(arrangedSubviews: [
            postsLabel,
            followersLabel,
            followingLabel
        ])
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(
            top: topAnchor, paddingTop: 12,
            left: profileImageView.rightAnchor, paddingLeft: 12,
            right: rightAnchor, paddingRight: 12,
            bottom: nil, paddingBottom: 0,
            width: 0, height: 50
        )
        
        usernameLabel.anchor(
            top: profileImageView.bottomAnchor, paddingTop: 4,
            left: leftAnchor, paddingLeft: 12,
            right: rightAnchor, paddingRight: 12,
            bottom: gridButton.topAnchor, paddingBottom: 0,
            width: 0, height: 0
        )
        
        editProfileFollowButton.anchor(
            top: postsLabel.bottomAnchor, paddingTop: 2,
            left: postsLabel.leftAnchor, paddingLeft: 0,
            right: followingLabel.rightAnchor, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 0, height: 34
        )
        
        
    }
    
    
    
    private func configureButtonToolbar() {
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [
            gridButton,
            listButton,
            bookmarkButton
        ])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(
            top: nil, paddingTop: 0,
            left: leftAnchor, paddingLeft: 0,
            right: rightAnchor, paddingRight: 0,
            bottom: bottomAnchor, paddingBottom: 0,
            width: 0, height: 50
        )
        
        addSubview(topDividerView)
        topDividerView.anchor(
            top: stackView.topAnchor, paddingTop: 0,
            left: leftAnchor, paddingLeft: 0,
            right: rightAnchor, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 0, height: 0.5
        )
        
        addSubview(bottomDividerView)
        bottomDividerView.anchor(
            top: stackView.bottomAnchor, paddingTop: 0,
            left: leftAnchor, paddingLeft: 0,
            right: rightAnchor, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 0, height: 0.5
        )
    }
}
