import UIKit
import Firebase

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
        
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(149, 204, 244, 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
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
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, !email.isEmpty  else { return }
        guard let userName = userNameTextField.text, !userName.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to create user:", error)
                return
            }
            
            print("Successfully created user:",result?.user.uid ?? "")
        }
    }
    
    @objc func handleTextInputChange() {
        
        let isValid = emailTextField.text?.count ?? 0 > 0 && userNameTextField.text?.count ?? 0 > 0 &&
            passwordTextField.text?.count ?? 0 > 0
        
        if isValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(17, 154, 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(149, 204, 244)
        }
        
    }
}


