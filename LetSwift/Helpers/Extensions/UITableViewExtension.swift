//
//  UITableViewExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 30.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UITableView {
    override open var delaysContentTouches: Bool {
        didSet {
            changeChildDelaysContentTouches()
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        changeChildDelaysContentTouches()
    }
    
    private func changeChildDelaysContentTouches() {
        for case let child as UIScrollView in subviews {
            child.delaysContentTouches = delaysContentTouches
        }
    }
}
