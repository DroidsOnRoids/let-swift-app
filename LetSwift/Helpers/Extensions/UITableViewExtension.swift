//
//  UITableViewExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UITableView {
    func clearFooter() {
        tableFooterView = UIView()
    }
    
    func setFooterColor(_ color: UIColor) {
        let footerSubview = UIView(frame: CGRect(origin: .zero, size: CGSize(width: bounds.width, height: 1000.0)))
        footerSubview.backgroundColor = color
        
        clearFooter()
        tableFooterView?.addSubview(footerSubview)
    }
}
