//
//  UITableViewCellExtenion.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 13.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func removeSeparators() {
        let largeIndent: CGFloat = .infinity
        separatorInset = UIEdgeInsets(top: 0.0, left: largeIndent, bottom: 0.0, right: 0.0)
        indentationWidth = largeIndent * -1.0
        indentationLevel = 1
    }
}
