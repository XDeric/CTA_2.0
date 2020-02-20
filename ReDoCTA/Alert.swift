//
//  Alert.swift
//  ReDoCTA
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import UIKit

struct Alerts {
    
    static func showAlert(withTitle title: String, andMessage message: String, VC: UIViewController) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        VC.present(alertVC, animated: true, completion: nil)
    }
}
