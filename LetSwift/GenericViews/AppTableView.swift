//
//  AppTableView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 23.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AppTableView: UITableView {
    
    var backgroundScrollsWithContent = false
    
    var appBackgroundView: UIView? = nil {
        willSet {
            appBackgroundView?.removeFromSuperview()
        }
        didSet {
            guard let appBackgroundView = appBackgroundView else { return }
            
            appBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            appBackgroundView.frame = bounds
            addSubview(appBackgroundView)
        }
    }
}
