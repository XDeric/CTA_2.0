//
//  FavoriteViewController.swift
//  ReDoCTA
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

 UIKit
import FirebaseAuth

class FavoriteViewController: UIViewController {
    
    var chosenAPI = String()
    var user = [AppUser]()
    var userFave = [Post](){
        didSet{
            tableList.reloadData()
        }
    }
    var artWork = [ArtObject]()
    
    lazy var tableList: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) //to see it for now change color later
        table.register(ThingsOnlineTableViewCell.self, forCellReuseIdentifier: "thingsCell")
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadPosts()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        self.navigationItem.title = "Favorites"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoffButton))
        loadUserDefaults()
        setupConstraints()
        
    }
    
    private func loadUserDefaults(){
        chosenAPI = UserDefaults.standard.object(forKey: "API") as? String ?? "Ticket Master"
    }
    
    @objc func logoffButton(){
        do {
            try Auth.auth().signOut()
            let VC = ViewController()
            VC.modalPresentationStyle = .fullScreen
            present(VC, animated: true, completion: nil)
            //dismiss(animated: true, completion: nil)
        } catch {print(error)}
    }
    
    //MARK: load firebase favorites
    
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
                    self.userFave = data
                }
            }
        }
    }
    
    //MARK: Like button function
    private func like(button: UIButton, title: String, body: String, price: Double, imageURL: String, postID: String){
        if button.backgroundImage(for: .normal) == UIImage(systemName: "heart") {
            button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            button.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            FirestoreService.manager.delete(postID: postID) { (result) in
                switch result{
                case .failure(let error):
                    print(error)
                case .success(()):
                    print("Deleted")
                }
            }
        }
    }
    
    
    
    //MARK: constraints
    
    private func setupConstraints(){
        tableList.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableList)

        NSLayoutConstraint.activate([
            
            tableList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
        
        
    }
    
    
}


//MARK: Tableview functions
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chosenAPI == "Ticket Master"{
            return userFave.count
        } else {
            return artWork.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableList.dequeueReusableCell(withIdentifier: "thingsCell", for: indexPath) as! ThingsOnlineTableViewCell
        
        if chosenAPI == "Ticket Master"{
            let ticketData = userFave[indexPath.row]
            ImageHelper.shared.getImage(urlStr: ticketData.imageURL) { (result) in
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
            cell.info.text = "\(ticketData.title) \n\(ticketData.price) \n\(ticketData.body)"
            cell.buttonFunction = { self.like(button: cell.likeButton, title: ticketData.title, body: ticketData.body ?? "n/a", price: ticketData.price ?? 0, imageURL: ticketData.imageURL, postID: ticketData.id ) }
        }
        else{
            let artData = artWork[indexPath.row]
            cell.image1.image = UIImage(named: "noPic")
            cell.info.text = "\(artData.longTitle) \(artData.principalOrFirstMaker)"
        }
        
        cell.image1.image = UIImage(named: "noPic")
        cell.info.text = userFave[indexPath.row].body
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
