import UIKit

class ViewController: UIViewController {
    
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "photoButton").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(149, 204, 244, 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(photoButton)

        photoButton.anchor(top: view.topAnchor, paddingTop: 40,
                           left: nil, paddingLeft: 0,
                           right: nil, paddingRight: 0,
                           bottom: nil, paddingBottom: 0,
                           width: 140, height: 140)
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputsFields()
    }
    
    fileprivate func setupInputsFields() {
        
        let stackView = UIStackView(arrangedSubviews: [
                                        emailTextField,
                                        userNameTextField,
                                        passwordTextField,
                                        signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)

        stackView.anchor(top: photoButton.bottomAnchor, paddingTop: 20,
                         left: view.leftAnchor, paddingLeft: 40,
                         right: view.rightAnchor, paddingRight: 40,
                         bottom: nil, paddingBottom: 0,
                         width: 0, height: 200)
    }    
}


