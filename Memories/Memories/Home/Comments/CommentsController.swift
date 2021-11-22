import UIKit
import Firebase



class CommentsController: UICollectionViewController {
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
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
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.cellIdentifier)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
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
    
    private func fetchCommets() {
        guard let postId = self.post?.id else { return }
        
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("comments")
            .child(postId)
            .observe(.childAdded) { snapshot in
                
                guard let dictionary = snapshot.value as? [String: Any],
                      let uid = dictionary["uid"] as? String else { return }
                
                Database.fetchUserWithUID(uid: uid) { user in
                    let comment = Comment(user: user, dictionary: dictionary)
                    self.comments.append(comment)
                    self.collectionView.reloadData()
                }
            } withCancel: { error in
                self.alert(message: error.localizedDescription, title: "Failed")
            }
    }
    
    //MARK: - Grid cell settings
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.cellIdentifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
        cell.comment = comments[indexPath.item]
        return cell
    }
}

extension CommentsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cell = CommentCell(frame: frame)
        cell.comment = comments[indexPath.item]
        cell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = cell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CommentsController: CommentInputAccessoryViewDelegate {
    func didTapSendButton(for comment: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let postId = self.post?.id ?? ""
        let values = ["text": comment, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
        
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("comments")
            .child(postId)
            .childByAutoId()
            .updateChildValues(values) { error, reference in
                if let error = error {
                    self.alert(message: error.localizedDescription, title: "Failed")
                    return
                }
                self.containerView.clearCommentTextField()
            }
    }
}

