//
//  UIFontExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UIFont {
    func withSize(_ size: CGFloat?) -> UIFont? {
        if let size = size {
           return withSize(size)
        }
        
        return nil
    }
}
