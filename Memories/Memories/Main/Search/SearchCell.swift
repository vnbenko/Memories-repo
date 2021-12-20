import UIKit

class SearchCell: UICollectionViewCell {
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    var user: User? {
        didSet {
            userNameLabel.text = user?.username
            guard let profileUserUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileUserUrl)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        addSubview(profileImageView)
        addSubview(userNameLabel)
        addSubview(separatorView)
        
        profileImageView.anchor(
            top: nil, paddingTop: 0,
            left: leftAnchor, paddingLeft: 8,
            right: nil, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        userNameLabel.anchor(
            top: topAnchor, paddingTop: 0,
            left: profileImageView.rightAnchor, paddingLeft: 8,
            right: rightAnchor, paddingRight: 0,
            bottom: bottomAnchor, paddingBottom: 0,
            width: 0, height: 0)
        
        separatorView.anchor(
            top: nil, paddingTop: 0,
            left: userNameLabel.leftAnchor, paddingLeft: 0,
            right: rightAnchor, paddingRight: 0,
            bottom: bottomAnchor, paddingBottom: 0,
            width: 0, height: 0.5)
        
    }
    
}
