//
//  UIButtonExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 30.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UIButton {
    private enum Constants {
        static let minimumHitArea = CGSize(width: 100, height: 100)
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let widthToAdd = max(Constants.minimumHitArea.width - bounds.width, 0)
        let heightToAdd = max(Constants.minimumHitArea.height - bounds.height, 0)
        let largerFrame = bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        
        return largerFrame.contains(point) ? self : nil
    }
}
