import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didTapSendButton(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    fileprivate let commentTextView: CommentInputTextView = {
        let textView = CommentInputTextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 18)
        return textView
    }()
    
    fileprivate let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    // 2
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        // 1
        autoresizingMask = .flexibleHeight
        
        addSubview(sendButton)
        sendButton.anchor(
            top: topAnchor, paddingTop: 0,
            left: nil, paddingLeft: 0,
            right: rightAnchor, paddingRight: 12,
            bottom: nil, paddingBottom: 0,
            width: 50, height: 50)
        
        addSubview(commentTextView)
        // 3
        commentTextView.anchor(
            top: topAnchor, paddingTop: 8,
            left: leftAnchor, paddingLeft: 8,
            right: sendButton.leftAnchor, paddingRight: 0,
            bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 8,
            width: 0, height: 0)
        
        setupLineSeparatorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSend() {
        guard let commentText = commentTextView.text else { return }
        delegate?.didTapSendButton(for: commentText)
    }
    
    func clearCommentTextField() {
        commentTextView.text = nil
        commentTextView.showPlaceholderLabel()
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparator = UIView()
        lineSeparator.backgroundColor = .rgb(230, 230, 230)
        addSubview(lineSeparator)
        lineSeparator.anchor(
            top: topAnchor, paddingTop: 0,
            left: leftAnchor, paddingLeft: 0,
            right: rightAnchor, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 0, height: 0.5)
    }
    
}



