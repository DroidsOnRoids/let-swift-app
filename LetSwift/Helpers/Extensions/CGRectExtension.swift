//
//  CGRectExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension CGRect {
    func scale(by k: CGFloat) -> CGRect {
        let newWidth = width * k
        let newHeight = height * k
        let newX = (width - newWidth) / 2
        let newY = (height - newHeight) / 2
        
        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }
}
