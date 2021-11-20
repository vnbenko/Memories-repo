import UIKit

class CommentCell: UICollectionViewCell {
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    static let cellIdentifier = "CommentCell"
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
            textView.attributedText = attributedText
            profileImageView.loadImage(urlString: comment.user.profileImageUrl)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - ConfigureUI
    
    private func configure() {
        configureImageViews()
        configureTextView()
    }
    
    private func configureImageViews() {
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, paddingTop: 8,
                                left: leftAnchor, paddingLeft: 8,
                                right: nil, paddingRight: 0,
                                bottom: nil, paddingBottom: 0,
                                width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
    }
    
    private func configureTextView() {
        addSubview(textView)
        
        textView.anchor(top: topAnchor, paddingTop: 4,
                        left: profileImageView.rightAnchor , paddingLeft: 4,
                        right: rightAnchor, paddingRight: 4,
                        bottom: bottomAnchor, paddingBottom: 4,
                        width: 0, height: 0)
    }
}
