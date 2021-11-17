import UIKit
import Firebase

class LoginController: UIViewController {
    
    
    let logoBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background_logo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "main_logo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleSignInAppearance), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleSignInAppearance), for: .editingChanged)
        return textField
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = .customLightBlue()
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var inputFieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            signInButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [
            .font : UIFont.systemFont(ofSize: 14),
            .foregroundColor : UIColor.lightGray
        ])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [
            .font : UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor : UIColor.customBlue()
        ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func handleSignInAppearance() {
        if emailTextField.hasText && passwordTextField.hasText {
            signInButton.isEnabled = true
            signInButton.backgroundColor = .customBlue()
        } else {
            signInButton.isEnabled = false
            signInButton.backgroundColor = .customLightBlue()
        }
    }
    
    @objc func handleSignIn() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) else { return}

        auth.signIn(withEmail: email, password: password) { data, error in
            
            if let error = error {
                print("Failed to sign in with email: ", error)
                return
            }
            
            print("Successfully logged back in with user: ", data?.user.uid ?? "")

            guard let mainTabBarController = UIApplication.shared.windows.filter ({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.showAllControllers()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(logoBackgroundImageView)
        logoBackgroundImageView.addSubview(logoImageView)
        view.addSubview(inputFieldsStackView)
        view.addSubview(signUpButton)
          
        logoBackgroundImageView.anchor(
            top: view.topAnchor, paddingTop: 0,
            left: view.leftAnchor, paddingLeft: 0,
            right: view.rightAnchor, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 0, height: 150
        )
        
        logoImageView.anchor(top: nil, paddingTop: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, bottom: logoBackgroundImageView.bottomAnchor, paddingBottom: 0, width: 0, height: 0)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: logoBackgroundImageView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
  
        inputFieldsStackView.anchor(
            top: logoBackgroundImageView.bottomAnchor, paddingTop: 40,
            left: view.leftAnchor, paddingLeft: 40,
            right: view.rightAnchor, paddingRight: 40,
            bottom: nil, paddingBottom: 0,
            width: 0, height: 140
        )
        
        signUpButton.anchor(
            top: nil, paddingTop: 0,
            left: view.leftAnchor, paddingLeft: 0,
            right: view.rightAnchor, paddingRight: 0,
            bottom: view.bottomAnchor, paddingBottom: 0,
            width: 0, height: 50
        )
    }
    
}
