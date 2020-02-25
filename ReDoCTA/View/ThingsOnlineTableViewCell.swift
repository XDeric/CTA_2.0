//
//  ThingsOnlineTableViewCell.swift
//  ReDoCTA
//
//  Created by EricM on 2/25/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import UIKit
import Foundation

class ThingsOnlineTableViewCell: UITableViewCell {
    
    lazy var image1: UIImageView = {
        let pic = UIImageView()
        pic.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        pic.contentMode = .scaleAspectFill
        pic.clipsToBounds = true
        return pic
    }()
    
    lazy var info: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        tv.isEditable = false
        tv.isScrollEnabled = true
        return tv
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 0)
        button.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var buttonFunction: (()->())?

    @objc private func likeButtonPressed() {
        if let closure = buttonFunction {
            closure()
        }
    }
    
    
    
    
    private func setupCell(){
        image1.translatesAutoresizingMaskIntoConstraints = false
        info.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(info)
        addSubview(image1)
        addSubview(likeButton)
        NSLayoutConstraint.activate([

            image1.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            image1.heightAnchor.constraint(equalToConstant: 200),
            image1.widthAnchor.constraint(equalToConstant: 150),
            
            likeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            likeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            info.leftAnchor.constraint(equalTo: image1.rightAnchor),
            info.rightAnchor.constraint(equalTo: likeButton.leftAnchor),
            info.heightAnchor.constraint(equalToConstant: 200)
            
        
        
        ])
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }


    
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}
