import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didTapSendButton(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    private let commentTextView: CommentInputTextView = {
        let textView = CommentInputTextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 18)
        return textView
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
      
        configure()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Delegate Actions
    
    @objc func handleSend() {
        guard let commentText = commentTextView.text else { return }
        delegate?.didTapSendButton(for: commentText)
    }
    
    // MARK: - Functions
    
    func clearCommentTextField() {
        commentTextView.text = nil
        commentTextView.showPlaceholderLabel()
    }
    
    
    // MARK: - Configure UI
    
    private func configure() {
        backgroundColor = .white
        configureButtons()
        configureTextView()
        configureSeparatorView()
    }

    private func configureButtons() {
        addSubview(sendButton)
        
        sendButton.anchor(
            top: topAnchor, paddingTop: 0,
            left: nil, paddingLeft: 0,
            right: rightAnchor, paddingRight: 12,
            bottom: nil, paddingBottom: 0,
            width: 50, height: 50)
    }
    
    private func configureTextView() {
        addSubview(commentTextView)
     
        commentTextView.anchor(
            top: topAnchor, paddingTop: 8,
            left: leftAnchor, paddingLeft: 8,
            right: sendButton.leftAnchor, paddingRight: 0,
            bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 8,
            width: 0, height: 0)
    }
    
    private func configureSeparatorView() {
        let lineSeparator = UIView()
        lineSeparator.backgroundColor = .customGray()
        addSubview(lineSeparator)
        lineSeparator.anchor(
            top: topAnchor, paddingTop: 0,
            left: leftAnchor, paddingLeft: 0,
            right: rightAnchor, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 0, height: 0.5)
    }
}



