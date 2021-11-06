import UIKit

class SharePhotoController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(240, 240, 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    @objc func handleShare() {
        print("sharing photo")
    }
    
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, bottom: nil, paddingBottom: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, paddingTop: 8, left: containerView.leftAnchor, paddingLeft: 8, right: nil, paddingRight: 0, bottom: containerView.bottomAnchor, paddingBottom: 8, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, paddingTop: 0, left: imageView.rightAnchor, paddingLeft: 4, right: containerView.rightAnchor, paddingRight: 0, bottom: containerView.bottomAnchor, paddingBottom: 0, width: 0, height: 0)
        
    }
}
