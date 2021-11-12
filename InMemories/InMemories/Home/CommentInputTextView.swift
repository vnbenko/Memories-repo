//
//  CommentInputTextView.swift
//  InMemories
//
//  Created by Meraki on 12.11.2021.
//

import UIKit

class CommentInputTextView: UITextView {
    
    
    fileprivate let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter comment..."
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(
            top: topAnchor, paddingTop: 8,
            left: leftAnchor, paddingLeft: 8,
            right: rightAnchor, paddingRight: 0,
            bottom: bottomAnchor, paddingBottom: 0,
            width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
}
