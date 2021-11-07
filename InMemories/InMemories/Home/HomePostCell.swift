import UIKit

class HomePostCell: UICollectionViewCell {
   
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let photoImageView: CustomImageView = {
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
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: imageUrl)

            userNameLabel.text = post?.user.username
            
            guard let profileUserImageUrl = post?.user.profileImage else { return }
            userProfileImageView.loadImage(urlString: profileUserImageUrl)

            setupAttributedCaption()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(userProfileImageView)
        addSubview(photoImageView)
        addSubview(userNameLabel)
        addSubview(optionsButton)
        addSubview(bookmarkButton)
        
        
        userProfileImageView.anchor(top: topAnchor, paddingTop: 8, left: leftAnchor, paddingLeft: 8, right: nil, paddingRight: 0, bottom: nil, paddingBottom: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, paddingTop: 8, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, bottom: nil, paddingBottom: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        userNameLabel.anchor(top: topAnchor, paddingTop: 0, left: userProfileImageView.rightAnchor, paddingLeft: 8, right: optionsButton.leftAnchor, paddingRight: 0, bottom: photoImageView.topAnchor, paddingBottom: 0, width: 0, height: 0)
        
        optionsButton.anchor(top: topAnchor, paddingTop: 0, left: nil, paddingLeft: 0, right: rightAnchor, paddingRight: 0, bottom: photoImageView.topAnchor, paddingBottom: 0, width: 44, height: 0)
        
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, paddingTop: 0, left: nil, paddingLeft: 0, right: rightAnchor, paddingRight: 0, bottom: nil, paddingBottom: 0, width: 40, height: 50)
        
        setupActionButtons()
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likeButton.bottomAnchor, paddingTop: 0, left: leftAnchor, paddingLeft: 8, right: rightAnchor, paddingRight: 8, bottom: bottomAnchor, paddingBottom: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, paddingTop: 0, left: leftAnchor, paddingLeft: 4, right: nil, paddingRight: 0, bottom: nil, paddingBottom: 0, width: 120, height: 50)
    }
    
    fileprivate func setupAttributedCaption() {
        
        guard let post = self.post else { return }
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [
            .font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [
            .font : UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: "1 week ago", attributes: [
            .font : UIFont.systemFont(ofSize: 14),
            .foregroundColor : UIColor.lightGray
        ]))
        self.captionLabel.attributedText = attributedText
    }
    
    
}
