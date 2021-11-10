import UIKit
import Firebase

class CommentsController: UICollectionViewController {
    
    let cellId = "cellId"
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        return textField
    }()
    
    //implement comment textfield andsend button onto a accessoryView.
    //lazy needs for commentTextFiels that's not in context of CommentsController
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        sendButton.anchor(top: containerView.topAnchor, paddingTop: 0, left: nil, paddingLeft: 0, right: containerView.rightAnchor, paddingRight: 12, bottom: containerView.bottomAnchor, paddingBottom: 0, width: 50, height: 0)
        
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.anchor(top: containerView.topAnchor, paddingTop: 0, left: containerView.leftAnchor, paddingLeft: 0, right: sendButton.leftAnchor, paddingRight: 0, bottom: containerView.bottomAnchor, paddingBottom: 0, width: 0, height: 0)
        return containerView
    }()
    
    override var inputAccessoryView: UIView?{
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var post: Post?
    
    var comments = [Comment]()
    
    
    //MARK: - Lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchCommets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Functions
    @objc func handleSend() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postId = self.post?.id ?? ""
        let values = ["text": commentTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
        
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("comments")
            .child(postId)
            .childByAutoId()
            .updateChildValues(values) { error, reference in
                if let error = error {
                    print("Failed to insert comment: ", error)
                    return
                }
                print("Successfully inserted comment")
            }
        
    }
    
    fileprivate func fetchCommets() {
        guard let postId = self.post?.id else { return }
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("comments")
            .child(postId)
            .observe(.childAdded) { snapshot in
                
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                let comment = Comment(dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView.reloadData()

            } withCancel: { error in
                print("Failed to observe comments: ", error)
            }
        
        
    }
    
    //MARK: - Grid cell settings
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
        cell.comment = comments[indexPath.item]
        return cell
    }
    
}

extension CommentsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}
