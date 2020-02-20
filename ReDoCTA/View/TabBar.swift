//
//  TabBar.swift
//  ReDoCTA
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {
    
    let mainVC = UINavigationController(rootViewController: ThingsFromOnlineViewController())
    let faveVC = UINavigationController(rootViewController: FavoriteViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainVC.tabBarItem = UITabBarItem(title: "Collection", image: UIImage(systemName: "tray"), tag: 0)
        faveVC.tabBarItem = UITabBarItem(title: "Fave", image: UIImage(systemName: "star"), tag: 1)
        self.viewControllers = [mainVC, faveVC]
    }
}
