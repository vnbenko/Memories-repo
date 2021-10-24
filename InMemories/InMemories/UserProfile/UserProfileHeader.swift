//
//  UserProfileHeader.swift
//  InMemories
//
//  Created by Meraki on 24.10.2021.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, paddingTop: 12, left: leftAnchor, paddingLeft: 12, right: nil, paddingRight: 0, bottom: nil, paddingBottom: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
    
    }
    
    var user: User? {
        didSet {
            setupProfileImage()
        }
    }
    
    fileprivate func setupProfileImage() {
        guard let userPhoto = user?.userPhoto else { return }
        guard let url = URL(string: userPhoto)  else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch profile image: ", error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode != 200 {
                print("Status code : ", httpResponse.statusCode)
                return
            }
            
            guard let data = data else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            
        }.resume()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
