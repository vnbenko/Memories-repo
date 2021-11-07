import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        return imageView
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
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
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [
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
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [
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
        let attributedText = NSMutableAttributedString(string: "45\n", attributes: [
            .font : UIFont.boldSystemFont(ofSize: 14)
        ])
        attributedText.append(NSAttributedString(string: "following", attributes: [
            .foregroundColor : UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 14)
        ]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImage else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            usernameLabel.text = user?.username
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(editProfileButton)
        
        setupButtonToolbar()
        setupUserStatsView()
        
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        profileImageView.anchor(
            top: topAnchor, paddingTop: 12,
            left: leftAnchor, paddingLeft: 12,
            right: nil, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 80, height: 80
        )
        
        usernameLabel.anchor(
            top: profileImageView.bottomAnchor, paddingTop: 4,
            left: leftAnchor, paddingLeft: 12,
            right: rightAnchor, paddingRight: 12,
            bottom: gridButton.topAnchor, paddingBottom: 0,
            width: 0, height: 0
        )

        editProfileButton.anchor(
            top: postsLabel.bottomAnchor, paddingTop: 2,
            left: postsLabel.leftAnchor, paddingLeft: 0,
            right: followingLabel.rightAnchor, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 0, height: 34
        )

    }
    
    fileprivate func setupUserStatsView() {
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
    }
    
    fileprivate func setupButtonToolbar() {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
