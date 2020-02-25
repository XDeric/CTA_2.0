//
//  ThingsFromOnlineViewController.swift
//  ReDoCTA
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ThingsFromOnlineViewController: UIViewController, UITextFieldDelegate{
    
    var chosenAPI = String()
        var ticket = [Event](){
            didSet{
                print(ticket.count)
                tableList.reloadData()
            }
        }
        var artWork = [ArtObject]()
        //    var chosenData = [Any]()
        
        //post data
        var userPost = [Post]()
        
        var searchString = String(){
            didSet{
                loadWhichData(search: searchString)
                //tableList.reloadData()
            }
        }
        
        lazy var tableList: UITableView = {
            let table = UITableView()
            table.dataSource = self
            table.delegate = self
            table.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) //to see it for now change color later
            table.register(ThingsOnlineTableViewCell.self, forCellReuseIdentifier: "thingsCell")
            return table
        }()
        
        lazy var searchText: UITextField = {
            let tf = UITextField()
            tf.placeholder = "Search and hit Enter"
            tf.font?.withSize(20)
            tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            tf.delegate = self
            return tf
        }()
        
        
        //MARK: Viewload life cycle
        //    override func viewWillAppear(_ animated: Bool) {
        //        super.viewWillAppear(true)
        //        setupConstraints()
        //    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
            loadUserDefaults()
            loadWhichData(search: searchString)
            //whichData()
            self.navigationItem.title = "Data"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoffButton))
            //self.view.addSubview(logout)
            setupConstraints()
            loadPosts()
        }
        
        //MARK: Loading data from api
        private func loadUserDefaults(){
            chosenAPI = UserDefaults.standard.object(forKey: "API") as? String ?? "Ticket Master"
        }
        
        private func loadWhichData(search: String){
            if chosenAPI == "Ticket Master" {
                loadTicketData(search: search)
            }else {
                loadRijks(search: search)
            }
        }
        
        private func loadPosts(){
            guard let user = FirebaseAuthService.manager.currentUser else {
                print("No user")
                return
            }
            FirestoreService.manager.getPosts(forUserID: user.uid) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let data):
                        self.userPost = data
                    }
                }
            }
        }

        
        private func loadTicketData(search: String ){
            TicketAPIClient.shared.getEvents(search: search) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let data):
                        self.ticket = data
                    }
                }
            }
        }
        
        private func loadRijks(search: String ){
            RijksAPIClient.shared.getArt(search: search) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let data):
                        self.artWork = data
                    }
                }
            }
        }
        
        
        //MARK: functions
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchString = textField.text ?? ""
            print(textField.text ?? "queens")
            textField.resignFirstResponder()
            
            return true
        }
        
        @objc func logoffButton(){
            do {
                try Auth.auth().signOut()
                            let VC = LoginVC()
                            VC.modalPresentationStyle = .fullScreen
                            present(VC, animated: true, completion: nil)

            } catch {print(error)}
        }
        
        //MARK: Like button
        private func like(button: UIButton, title: String, body: String, price: Double, imageURL: String){
            if button.backgroundImage(for: .normal) == UIImage(systemName: "heart") {
                button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                //current user
                guard let user = FirebaseAuthService.manager.currentUser else {
                    print("No user")
                    return
                }
                //creating post for current user
                let post = Post(title: title, body: body, creatorID: user.uid, price: price, imageURL: imageURL)
                FirestoreService.manager.createPost(post: post) { (result) in
                    switch result{
                    case .failure(let error):
                        print(error)
                    case .success(()):
                        print("data posted")
                    }
                }
            } else {
                button.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        
        
        //MARK: Autolayout
        
        private func setupConstraints(){
            searchText.translatesAutoresizingMaskIntoConstraints = false
            tableList.translatesAutoresizingMaskIntoConstraints = false

            self.view.addSubview(searchText)
            self.view.addSubview(tableList)
            
            NSLayoutConstraint.activate([

                searchText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchText.heightAnchor.constraint(equalToConstant: 60),
                searchText.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                searchText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                tableList.topAnchor.constraint(equalTo: searchText.bottomAnchor),
                tableList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                tableList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                tableList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
            
        }
        
    }


    //MARK: Tableview functions
    extension ThingsFromOnlineViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if chosenAPI == "Ticket Master"{
                return ticket.count
            } else {
                return artWork.count
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableList.dequeueReusableCell(withIdentifier: "thingsCell", for: indexPath) as! ThingsOnlineTableViewCell
            
            if chosenAPI == "Ticket Master"{
                let ticketData = ticket[indexPath.row]
                ImageHelper.shared.getImage(urlStr: ticketData.images[0].url) { (result) in
                    DispatchQueue.main.async {
                        switch result{
                        case .failure(let error):
                            print(error)
                        case .success(let image):
                            cell.image1.image = image
                        }
                    }
                }
                //cell.image1.image = UIImage(named: "noPic")
                cell.info.text = "\(ticketData.name) \n\(ticketData.dates.start.localDate) \n\(ticketData.info ?? "n/a")"
                // button function called
                cell.buttonFunction = { self.like(button: cell.likeButton, title: ticketData.name, body: ticketData.info ?? "n/a", price: ticketData.priceRanges?[0].max ?? 0, imageURL: ticketData.images[0].url) }
            }
            else{
                let artData = artWork[indexPath.row]
                cell.image1.image = UIImage(named: "noPic")
                cell.info.text = "\(artData.longTitle) \(artData.principalOrFirstMaker)"
            }
            
            cell.image1.image = UIImage(named: "noPic")
            cell.info.text = ticket[indexPath.row].info
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 200
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailVC = DetailViewController()
            let currentData = ticket[indexPath.row]
            detailVC.tikData = currentData
            detailVC.modalPresentationStyle = .fullScreen
            detailVC.modalTransitionStyle = .crossDissolve
            present(detailVC, animated: true, completion: nil)
        }
    }

