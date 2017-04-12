//
//  UIColorExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 12.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }

    public class var swiftOrange: UIColor {
        return UIColor(red: 255.0, green: 192.0, blue: 55.0)
    }
}
