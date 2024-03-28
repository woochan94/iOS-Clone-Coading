//
//  RegisterController.swift
//  InstagramClone
//
//  Created by 정우찬 on 2024/03/18.
//

import FirebaseAuth
import UIKit

class RegisterController: UIViewController {
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    private lazy var plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: UITextField = {
        let textField = CustomTextField(placeholder: "Email")
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let fullNameTextField: UITextField = {
        let textField = CustomTextField(placeholder: "FullName")
        return textField
    }()
    
    private let userNameTextField: UITextField = {
        let textField = CustomTextField(placeholder: "UserName")
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        button.backgroundColor = viewModel.buttonBackgroundColor
        button.layer.cornerRadius = 5
        button.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, userNameTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account?", secondPart: "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Actions
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender === passwordTextField {
            viewModel.password = sender.text
        } else if sender === fullNameTextField {
            viewModel.fullName = sender.text
        } else if sender === userNameTextField {
            viewModel.userName = sender.text
        }
        
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = viewModel.formIsValid
    }
    
    @objc func handleProfilePhotoSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let userName = userNameTextField.text else { return }
        guard let profileImage = profileImage else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullName: fullName, userName: userName, profileImage: profileImage)
        
        viewModel.registerUser(withCredential: credentials) { [weak self] response, error in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                return
            }
            
            guard let customToken = response?.customToken else { return }
            
            Auth.auth().signIn(withCustomToken: customToken) { authResult, error in
                if let error = error {
                    print("DEBUG: Custom Token 인증 실패: \(error.localizedDescription)")
                } else {
                    // 사용자 인증 성공 시
                    if let user = authResult?.user {
                        // 사용자의 ID 토큰을 가져와서 저장
                        user.getIDToken { idToken, error in
                            if let error = error {
                                print("DEBUG: ID 토큰 가져오기 실패: \(error.localizedDescription)")
                                do {
                                    try Auth.auth().signOut()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            } else if let idToken = idToken {
                                // ID 토큰을 저장
                                UserDefaults.standard.set(idToken, forKey: "idToken")
                                if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                    scene.showMainTabController()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(140)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
        }
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(plusPhotoButton.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(32)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectedImage
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true)
    }
}
