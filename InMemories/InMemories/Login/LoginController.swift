import UIKit

class LoginController: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        
        view.addSubview(logoImageView)
        
        logoImageView.anchor(
            top: nil, paddingTop: 0,
            left: nil, paddingLeft: 0,
            right: nil, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 200, height: 50
        )
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = UIColor.rgb(0, 120, 175)
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
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
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LogIn", for: .normal)
        button.backgroundColor = UIColor.rgb(149, 204, 244, 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.isEnabled = false
        return button
    }()
    
    let dontHaveAcountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an acount?  ", attributes: [
            .font : UIFont.systemFont(ofSize: 14),
            .foregroundColor : UIColor.lightGray
        ])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up.", attributes: [
            .font : UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor : UIColor.rgb(17, 154, 237)
        ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(
            top: view.topAnchor, paddingTop: 0,
            left: view.leftAnchor, paddingLeft: 0,
            right: view.rightAnchor, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 0, height: 150
        )
        
        view.addSubview(dontHaveAcountButton)
        dontHaveAcountButton.anchor(
            top: nil, paddingTop: 0,
            left: view.leftAnchor, paddingLeft: 0,
            right: view.rightAnchor, paddingRight: 0,
            bottom: view.bottomAnchor, paddingBottom: 0,
            width: 0, height: 50
        )
        
        setupInputsFields()
    }
    
    fileprivate func setupInputsFields() {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(
            top: logoContainerView.bottomAnchor, paddingTop: 40,
            left: view.leftAnchor, paddingLeft: 40,
            right: view.rightAnchor, paddingRight: 40,
            bottom: nil, paddingBottom: 0,
            width: 0, height: 140
        )
    }
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
        
    }
}
