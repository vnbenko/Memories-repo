import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
    
    static let headerId = "headerId"
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let resizeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "resize")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.alpha = 0.6
        button.addTarget(self, action: #selector(handleImageContent), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Action
    
    @objc func handleImageContent() {
        if photoImageView.contentMode == .scaleAspectFit {
            photoImageView.contentMode = .scaleAspectFill
        } else {
            photoImageView.contentMode = .scaleAspectFit
        }
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        addSubview(photoImageView)
        addSubview(resizeButton)
        
        photoImageView.anchor(
            top: topAnchor, paddingTop: 0,
            left: leftAnchor, paddingLeft: 0,
            right: rightAnchor, paddingRight: 0,
            bottom: bottomAnchor, paddingBottom: 0,
            width: 0, height: 0)
        
        resizeButton.anchor(
            top: nil, paddingTop: 0,
            left: photoImageView.leftAnchor, paddingLeft: 10,
            right: nil, paddingRight: 0,
            bottom: photoImageView.bottomAnchor, paddingBottom: 10,
            width: 30, height: 30)
    }
}
