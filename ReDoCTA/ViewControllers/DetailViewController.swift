//
//  DetailViewController.swift
//  ReDoCTA
//
//  Created by EricM on 2/25/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var chosenAPI = String()
    var tikData: Event?
    var artData: ArtObject!
    var artDetail = [ArtInfo]()
    
    lazy var detailImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        return image
    }()
    
    lazy var textInfo: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        tv.isScrollEnabled = true
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 0)
        button.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(like), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        loadUserDefaults()
        setupConstraints()
        //loadRijksDetail(ID: artData.objectNumber)
        showText()
        showImage()
    }
    
    private func loadRijksDetail(ID: String){
        RijksDetailAPI.shared.getDetail(artID: ID) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self.artDetail = [data]
                }
            }
        }
    }
    
    @objc func like(){
        if likeButton.backgroundImage(for: .normal) == UIImage(systemName: "heart") {
            likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @objc func backPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showText(){
        textInfo.text = "Starts: \(tikData?.dates.start.localDate ?? "n/a") \nName: \(tikData?.name ?? "n/a") \nCost: $\(tikData?.priceRanges?[0].max ?? 0) \nSite: \(tikData?.url ?? "No Website")"
    }
    
    private func showImage(){
        ImageHelper.shared.getImage(urlStr: tikData?.images[0].url ?? "https://sterlingcomputers.com/wp-content/themes/Sterling/images/no-image-found-360x260.png") { (result) in
            DispatchQueue.main.async {
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let image):
                    self.detailImage.image = image
                }
            }
        }
    }
    
    private func loadUserDefaults(){
        chosenAPI = UserDefaults.standard.object(forKey: "API") as? String ?? "Ticket Master"
    }
    
    //MARK: Constraints
    private func setupConstraints(){
        detailImage.translatesAutoresizingMaskIntoConstraints = false
        textInfo.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailImage)
        view.addSubview(textInfo)
        view.addSubview(likeButton)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            
            detailImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            detailImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailImage.heightAnchor.constraint(equalToConstant: 300),
            
            textInfo.topAnchor.constraint(equalTo: detailImage.bottomAnchor, constant: 10),
            textInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textInfo.heightAnchor.constraint(equalToConstant: 300),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor , constant: 50),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            likeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            likeButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            likeButton.heightAnchor.constraint(equalToConstant: 45),
            likeButton.widthAnchor.constraint(equalToConstant: 45)
            
        ])
    }
    
    
    
}
