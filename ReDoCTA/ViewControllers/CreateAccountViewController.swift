//
//  CreateAccountViewController.swift
//  ReDoCTA
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController {
    
    var selectedApi = String(){
        didSet{
            //TODO do something when slectedApi gets set
            UserDefaults.standard.set(selectedApi, forKey: "API")
        }
    }
    
    
    //MARK: view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        setupCreateStackView()
        setupBackButton()
        
        // Do any additional setup after loading the view.
    }
    //MARK: items on view
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return textField
    }()
    
    
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return textField
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignupPressed), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    lazy var back: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font.withSize(18)
        label.numberOfLines = 2
        label.text = "Choose your API/Website you wish to interact with"
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font.withSize(25)
        label.text = "Create an Account"
        return label
    }()
    
    lazy var picker: UIPickerView = {
        let pick = UIPickerView()
        pick.dataSource = self
        pick.delegate = self
        return pick
    }()
    
    //MARK: items functions
    
    @objc func handleShowLogin() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func formValidation() {
        guard emailTextField.hasText, passwordTextField.hasText else {
            signUpButton.backgroundColor = UIColor(red: 129/255, green: 93/255, blue: 93/255, alpha: 1)
            signUpButton.isEnabled = false
            return
        }
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
    }
    
    
    @objc func handleSignupPressed() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(withTitle: "Error", andMessage: "Failed to create account")
            print("Failed to sign up")
            return
        }
        FirebaseAuthService.manager.createNewUser(withEmail: email, password: password) { [weak self] (result) in
            self?.handleCreateAccountResponse(with: result)
        }
    }
    
    private func handleCreateAccountResponse(with result: Result<User, Error>) {
        switch result {
        case .success(let user):
            FirebaseAuthService.manager.updateUserName(userName: self.emailTextField.text ?? "NA")
            FirestoreService.manager.createAppUser(user: AppUser(from: user)) { [weak self] newResult in
                self?.handleCreatedUserInFirestore(result: newResult)
            }
        case .failure(let error):
            showAlert(withTitle: "Error creating user", andMessage: "an error occured while creating new account \(error)")
        }
    }
    
    private func handleCreatedUserInFirestore(result: Result<Void, Error>) {
        switch result {
        case .success:
            let mainVC = TabBar()
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true, completion: nil)
            
        case .failure(let error):
            print("error adding user to firestore \(error)")
        }
    }
    
    @objc func backPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(withTitle title: String, andMessage message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: Setup constraints
    
    private func setupCreateStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,emailTextField,passwordTextField,instructionLabel, picker,signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fill
        self.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
    }
    private func setupBackButton(){
        back.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: view.topAnchor , constant: 50),
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])
    }
    
    
    
    
}

extension CreateAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        APIList.list.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        APIList.list[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedApi = APIList.list[row]
    }

}
