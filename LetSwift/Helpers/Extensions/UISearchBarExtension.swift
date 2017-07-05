//
//  UISearchBarExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 05.07.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UISearchBar {
    func enableCancelButton() {
        subviews.flatMap({$0.subviews}).forEach({ ($0 as? UIButton)?.isEnabled = true })
    }
}
