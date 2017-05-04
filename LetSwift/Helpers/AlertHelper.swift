//
//  AlertHelper.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 04.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AlertHelper {
    
    private init() {}
    
    static func showAlert(withTitle title: String, message: String?, on viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        viewController.present(alertController, animated: true)
    }
}
