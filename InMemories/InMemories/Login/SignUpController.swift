import UIKit
import Firebase

class SignUpController: UIViewController {
    
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleSignUpAppearance), for: .editingChanged)
        return textField
    }()
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleSignUpAppearance), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleSignUpAppearance), for: .editingChanged)
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .customLightBlue()
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    lazy var inputFieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            userNameTextField,
            passwordTextField,
            signUpButton
        ])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(
            string: "Already have an account?  ",
            attributes: [
                .font : UIFont.systemFont(ofSize: 14),
                .foregroundColor : UIColor.lightGray
            ])
        
        attributedTitle.append(NSAttributedString(
            string: "Sign In",
            attributes: [
                .font : UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor : UIColor.customBlue()]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func handlePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty  else { return }
        guard let username = userNameTextField.text?.trimmingCharacters(in: .whitespaces), !username.isEmpty else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces), !password.isEmpty else { return }
        
        //MARK: Create a new user
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
           
            if let error = error {
                print("Failed to create user: ", error)
                return
            }
            
            print("Successfully created user: ", result?.user.uid ?? "")
            
            //MARK: Upload user's photo to the storage
            guard let image = self.photoButton.imageView?.image,
                  let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            
            let storageReference = Storage.storage().reference()
                .child("profile_images")
                .child(UUID().uuidString)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storageReference.putData(uploadData, metadata: metadata) { (metadata, error) in
                
                if let error = error {
                    print("Failed to upload profile image: ", error)
                    return
                }
                
                print("Successfully uploaded profile image: ", metadata?.name ?? "")
                
                //MARK: Get a link to a photo's URL
                storageReference.downloadURL { (url, error) in
                   
                    if let error = error {
                        print("Failed to get image's URL: ", error)
                        return
                    }
                    
                    print("Successfully got image's URL: ", url?.absoluteURL ?? "")
                    
                    //MARK: Write user information to the database
                    guard let imageURL = url?.absoluteString,
                          let uid = result?.user.uid else { return }
                    
                    let dictionaryValues = [
                        "username" : username,
                        "profileImage" : imageURL
                    ]
                    
                    let values = [uid : dictionaryValues]
                    
                    Database.database(url : Constants.shared.databaseUrlString).reference()
                        .child("users")
                        .updateChildValues(values) { (error, reference) in
                           
                            if let error = error {
                                print("Failed to save user info to db: ", error)
                                return
                            }
                            
                            print("Successfully saved user info to db: ", reference.url)
                            
                            guard let mainTabBarController = UIApplication.shared.windows.filter ({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController else { return }
                            
                            mainTabBarController.showAllControllers()
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                } 
            }
        }
    }
    
    @objc func handleSignUpAppearance() {
        
        if emailTextField.hasText && userNameTextField.hasText && passwordTextField.hasText {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .customBlue()
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .customLightBlue()
        }
    }
    
    @objc func handleSignIn() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(photoButton)
        view.addSubview(inputFieldsStackView)
        view.addSubview(signInButton)

        photoButton.anchor(
            top: view.topAnchor, paddingTop: 40,
            left: nil, paddingLeft: 0,
            right: nil, paddingRight: 0,
            bottom: nil, paddingBottom: 0,
            width: 140, height: 140
        )
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        inputFieldsStackView.anchor(
            top: photoButton.bottomAnchor, paddingTop: 20,
            left: view.leftAnchor, paddingLeft: 40,
            right: view.rightAnchor, paddingRight: 40,
            bottom: nil, paddingBottom: 0,
            width: 0, height: 200
        )
        
        signInButton.anchor(
            top: nil, paddingTop: 0,
            left: view.leftAnchor, paddingLeft: 0,
            right: view.rightAnchor, paddingRight: 0,
            bottom: view.bottomAnchor, paddingBottom: 0,
            width: 0, height: 50
        )
    }
 
}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            //without .withRenderingMode(.alwaysOriginal) we get a blue image instead of chosen photo
            photoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            photoButton.setImage(originalImage, for: .normal)
        }
        
        photoButton.layer.cornerRadius = photoButton.frame.height / 2
        photoButton.layer.masksToBounds = true
        photoButton.layer.borderColor = UIColor.black.cgColor
        photoButton.layer.borderWidth = 1
        
        dismiss(animated: true, completion: nil)
    }
}

