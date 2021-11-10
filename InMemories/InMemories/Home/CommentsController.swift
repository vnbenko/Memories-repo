import UIKit

class CommentsController: UICollectionViewController {
    
    //implement comment textfield andsend button onto a accessoryView
    var containerView: UIView = {
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
        
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        containerView.addSubview(textField)
        textField.anchor(top: containerView.topAnchor, paddingTop: 0, left: containerView.leftAnchor, paddingLeft: 0, right: sendButton.leftAnchor, paddingRight: 0, bottom: containerView.bottomAnchor, paddingBottom: 0, width: 0, height: 0)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .red
        
        navigationItem.title = "Comments"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    @objc func handleSend() {
        
    }

    
    
}
