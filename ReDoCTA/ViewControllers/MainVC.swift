//
//  ViewController.swift
//  ReDoCTA
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "CTA 2.0"
        return label
    }()
    
    lazy var userNameText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "UserName"
        
        return tf
    }()
    
    lazy var passwordText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        
        return tf
    }()

    
    lazy var logIn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6798086851, green: 0.9229053351, blue: 0.9803921569, alpha: 1)
        button.setTitle(title, for: .normal)
        button.titleLabel?.text = "Log In"
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var signIn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6798086851, green: 0.9229053351, blue: 0.9803921569, alpha: 1)
        button.setTitle(title, for: .normal)
        button.titleLabel?.text = "Sign In"
        button.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func logInPressed(){
        
    }
    @objc func signInPressed(){
        
    }
    
    func setupConstraints(){
        let items: [UIView] = [label,userNameText,passwordText,logIn,signIn]
        items.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        items.forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            
            userNameText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            userNameText.widthAnchor.constraint(equalToConstant: 200),
            userNameText.heightAnchor.constraint(equalToConstant: 60),
            
            passwordText.topAnchor.constraint(equalTo: userNameText.bottomAnchor, constant: 10),
            passwordText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordText.heightAnchor.constraint(equalToConstant: 60),
            passwordText.widthAnchor.constraint(equalToConstant: 200),
            
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
        // Do any additional setup after loading the view.
    }


}

