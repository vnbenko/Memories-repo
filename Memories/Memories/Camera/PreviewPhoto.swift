import UIKit
import Photos

class PreviewPhoto: UIView {
    
    static let showButtonsNotificationName = NSNotification.Name("Show Buttons")
    
    let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let popUpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = UIColor(white: 0, alpha: 0.3)
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "save_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let removePreviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cancel")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleRemovePreview), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.post(name: PreviewPhoto.showButtonsNotificationName, object: nil)
        configure()
    }

    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Actions
    
    @objc func handleSave() {
        guard let previewImage = previewImageView.image else { return }
        
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        } completionHandler: { success, error in
            
            if error != nil  {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showPopUpMessageWithAnimating("Something went wrong")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.removeFromSuperview()
                    }
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showPopUpMessageWithAnimating("Saved")
                self.saveButton.isHidden = true
            }
        }
    }
    
    @objc func handleRemovePreview() {
        self.removeFromSuperview()
    }
    
    // MARK: - Functions
    
    private func showPopUpMessageWithAnimating(_ text: String) {
        popUpLabel.text = text
        popUpLabel.center = self.center
        self.addSubview(popUpLabel)
        
        animatePopUpMessage()
    }
    
    private func animatePopUpMessage() {
        popUpLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.popUpLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
        } completion: { completed in
            UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                self.popUpLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                self.popUpLabel.alpha = 0
            } completion: { _ in
                self.popUpLabel.removeFromSuperview()
            }
        }
    }
    
    // MARK: - ConfigureUI
    
    private func configure() {
        configureImageViews()
        configureButtons()
    }
    
    private func configureImageViews() {
        addSubview(previewImageView)
  
        previewImageView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                                left: leftAnchor, paddingLeft: 0,
                                right: rightAnchor, paddingRight: 0,
                                bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 50,
                                width: 0, height: 0)
    }
    
    private func configureButtons() {
        addSubview(removePreviewButton)
        addSubview(saveButton)
        
        removePreviewButton.anchor(top: previewImageView.topAnchor, paddingTop: 12,
                                   left: previewImageView.leftAnchor, paddingLeft: 12,
                                   right: nil, paddingRight: 0,
                                   bottom: nil, paddingBottom: 0, width: 50, height: 50)
        
        saveButton.anchor(top: nil, paddingTop: 0,
                          left: leftAnchor, paddingLeft: 12,
                          right: nil, paddingRight: 0,
                          bottom: bottomAnchor, paddingBottom: 12,
                          width: 50, height: 50)
    }
}
