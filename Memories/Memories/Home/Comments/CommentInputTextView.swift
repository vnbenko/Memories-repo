//
//  CommentInputTextView.swift
//  InMemories
//
//  Created by Meraki on 12.11.2021.
//

import UIKit

class CommentInputTextView: UITextView {
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter comment..."
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
       
        subscribeNotificathion()
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Actions
    @objc func handleTextChange() {
        placeholderLabel.isHidden = self.hasText
    }

    // MARK: - Functions
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    private func subscribeNotificathion() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    // MARK: - Configure UI
    
    private func configure() {
        configureLabels()
    }
    
    private func configureLabels() {
        addSubview(placeholderLabel)
        
        placeholderLabel.anchor(top: topAnchor, paddingTop: 8,
                                left: leftAnchor, paddingLeft: 8,
                                right: rightAnchor, paddingRight: 0,
                                bottom: bottomAnchor, paddingBottom: 0,
                                width: 0, height: 0)
    }
}
