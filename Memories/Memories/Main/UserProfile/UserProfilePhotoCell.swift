import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    let photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: imageUrl)
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
        addSubview(photoImageView)
        
        photoImageView.anchor(
            top: topAnchor, paddingTop: 0,
            left: leftAnchor, paddingLeft: 0,
            right: rightAnchor, paddingRight: 0,
            bottom: bottomAnchor, paddingBottom: 0,
            width: 0, height: 0)
    }
    
}
