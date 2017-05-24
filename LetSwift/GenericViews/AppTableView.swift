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
        didSet {
            guard let appBackgroundView = appBackgroundView else {
                separatorStyle = .singleLine
                backgroundView = nil
                tableFooterView?.isHidden = false
                return
            }
            
            let backgroundContainer = UIView()
            appBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundContainer.addSubview(appBackgroundView)
            
            separatorStyle = .none
            backgroundView = backgroundContainer
            tableFooterView?.isHidden = true
        }
    }
    
    override var contentOffset: CGPoint {
        didSet {
            contentOffsetHasChanged()
        }
    }
    
    private func contentOffsetHasChanged() {
        appBackgroundView?.transform = backgroundScrollsWithContent ? CGAffineTransform(translationX: 0.0, y: -contentOffset.y) : .identity
    }
}
