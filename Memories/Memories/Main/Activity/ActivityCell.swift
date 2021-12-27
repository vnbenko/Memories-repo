//
//  ActivityCell.swift
//  Memories
//
//  Created by Meraki on 26.12.2021.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    
    static let cellId = "cellId"
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Username ", attributes: [.font : UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: "started following you.", attributes: [.font : UIFont.systemFont(ofSize: 12)]))
        label.attributedText = attributedText
        label.numberOfLines = 3
        return label
    }()
    
    let followingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Following", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        
        button.addTarget(self, action: #selector(handleFollowing), for: .touchUpInside)
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    
    var user: User? {
        didSet {
            userNameLabel.text = user?.username
            guard let profileUserUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileUserUrl)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    @objc private func handleFollowing() {
        
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        addSubview(profileImageView)
        addSubview(followingButton)
        addSubview(userNameLabel)
        addSubview(separatorView)
        
        profileImageView.anchor(
            top: nil, paddingTop: 0,
            left: leftAnchor, paddingLeft: 8,
            right: nil, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        followingButton.anchor(
            top: nil, paddingTop: 0,
            left: nil, paddingLeft: 0,
            right: rightAnchor, paddingRight: 8,
            bottom: nil, paddingBottom: 0,
            width: 100, height: 25)
        followingButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        userNameLabel.anchor(
            top: topAnchor, paddingTop: 0,
            left: profileImageView.rightAnchor, paddingLeft: 8,
            right: followingButton.leftAnchor, paddingRight: 8,
            bottom: bottomAnchor, paddingBottom: 0,
            width: 0, height: 0)
        
        separatorView.anchor(
            top: nil, paddingTop: 0,
            left: userNameLabel.leftAnchor, paddingLeft: 0,
            right: rightAnchor, paddingRight: 0,
            bottom: bottomAnchor, paddingBottom: 0,
            width: 0, height: 0.5)
    }
    
}
