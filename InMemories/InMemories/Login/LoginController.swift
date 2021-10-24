//
//  LoginController.swift
//  InMemories
//
//  Created by Meraki on 24.10.2021.
//

import UIKit

class LoginController: UIViewController {
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an acount? Sign Up.", for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(signUpButton)
        signUpButton.anchor(top: nil, paddingTop: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, bottom: view.bottomAnchor, paddingBottom: 0, width: 0, height: 50)
    }
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
        
    }
}
