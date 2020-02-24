//
//  MainVC.swift
//  ReDoCTA
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "CTA 2.0"
        return label
    }()
    
    lazy var userNameText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "UserName"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    lazy var passwordText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    lazy var logIn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6798086851, green: 0.9229053351, blue: 0.9803921569, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var signIn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6798086851, green: 0.9229053351, blue: 0.9803921569, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func logInPressed(){
        guard let email = userNameText.text, email != "", let password = passwordText.text, password != "" else {
            self.showAlert(withTitle: "Error", andMessage: "Invalid Fields")
            return
        }
        FirebaseAuthService.manager.loginUser(withEmail: email, password: password) { (result) in
            self.handleLoginResponse(with: result)
        }
    }
    
    @objc func signUpPressed(){
        let signupVC = CreateAccountViewController()
        self.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true)
    }
    
    private func handleLoginResponse(with result: Result<User,Error>) {
        switch result{
        case .failure(let error):
            self.showAlert(withTitle: "Error", andMessage: "\(error)")
        case .success:
            let vc = TabBar()
            vc.modalPresentationStyle = .fullScreen
            vc.present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK: Constraints
    func setupConstraints(view: UIView){
        let items: [UIView] = [label,userNameText,passwordText,logIn,signIn]
        items.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        items.forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            
            userNameText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            userNameText.widthAnchor.constraint(equalToConstant: 300),
            userNameText.heightAnchor.constraint(equalToConstant: 60),
            
            passwordText.topAnchor.constraint(equalTo: userNameText.bottomAnchor, constant: 10),
            passwordText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordText.heightAnchor.constraint(equalToConstant: 60),
            passwordText.widthAnchor.constraint(equalToConstant: 300),
            
            logIn.topAnchor.constraint(equalTo: passwordText.bottomAnchor, constant: 10),
            logIn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logIn.widthAnchor.constraint(equalToConstant: 100),
            logIn.heightAnchor.constraint(equalToConstant: 50),
            
            signIn.topAnchor.constraint(equalTo: logIn.bottomAnchor, constant: 10),
            signIn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signIn.widthAnchor.constraint(equalToConstant: 100),
            signIn.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        setupConstraints(view: self.view)
        // Do any additional setup after loading the view.
    }
    
}

//MARK: Extension
extension LoginVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField,_ textField2: UITextField) -> Bool {
        return true
    }
}

