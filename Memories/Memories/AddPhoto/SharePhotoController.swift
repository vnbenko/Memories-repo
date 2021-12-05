import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    static let updateFeedNotificationName = NSNotification.Name("UpdateFeed")
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
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
        
        view.backgroundColor = .customGray()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    @objc func handleShare() {
        guard let image = selectedImage,
              let uploadata = image.jpegData(compressionQuality: 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let fileName = UUID().uuidString
        
        let storageReference = Storage.storage().reference()
            .child("posts")
            .child(fileName)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageReference.putData(uploadata, metadata: metadata) { [weak self] metadata, error in
            guard let self = self else { return }
            
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload image: ", error)
                return
            }
            
            print("Successfully uploaded post image: ", metadata?.name ?? "")
            
            storageReference.downloadURL(completion: { [weak self] url, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Failed to upload image: ", error)
                    return
                }
                guard let imageUrl = url?.absoluteString else { return }
                print("Successfully got post image url: ", imageUrl)
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            })

        }
    }
    
    private func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database(url: Constants.shared.databaseUrlString).reference().child("posts").child(uid)
        
        let ref = userPostRef.childByAutoId()
        
        let values = [
            "imageUrl": imageUrl,
            "caption": caption,
            "imageWidth": postImage.size.width,
            "imageHeight": postImage.size.height,
            "creationDate": Date().timeIntervalSince1970
        ] as [String : Any]
        
        ref.updateChildValues(values) { [weak self] error, reference in
            guard let self = self else { return }
            
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB: ", error)
                return
            }
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
            
            
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }
    
    private func setupImageAndTextViews() {
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, bottom: nil, paddingBottom: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, paddingTop: 8, left: containerView.leftAnchor, paddingLeft: 8, right: nil, paddingRight: 0, bottom: containerView.bottomAnchor, paddingBottom: 8, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, paddingTop: 0, left: imageView.rightAnchor, paddingLeft: 4, right: containerView.rightAnchor, paddingRight: 0, bottom: containerView.bottomAnchor, paddingBottom: 0, width: 0, height: 0)
        
    }
}
