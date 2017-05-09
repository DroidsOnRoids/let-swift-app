//
//  PopoverView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 08.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class PopoverView: UIView {
    
    private enum Constants {
        static let straightRight: CGFloat = 0.0
        static let straightLeft = CGFloat(Float.pi)
        static let straightUp = CGFloat(Float.pi * 3.0 / 2.0)
        static let straightDown = CGFloat(Float.pi / 2.0)
    }
    
    override var bounds: CGRect {
        didSet {
            updateMask()
        }
    }
    
    var arrowWidth = 8.0 {
        didSet {
            updateMask()
        }
    }
    
    var arrowHeight = 4.0 {
        didSet {
            updateMask()
        }
    }
    
    var arrowPosition = 0.5 {
        didSet {
            if arrowPosition < 0.0 {
                arrowPosition = 0.0
            }
            if arrowPosition > 1.0 {
                arrowPosition = 1.0
            }
            
            updateMask()
        }
    }
    
    var cornerRadius = 6.0 {
        didSet {
            updateMask()
        }
    }
    
    var childRect: CGRect {
        return CGRect(x: 0.0, y: arrowHeight, width: Double(bounds.width), height: Double(bounds.height) - arrowHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateMask()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func updateMask() {
        let path = UIBezierPath()
        let width = Double(bounds.width)
        let height = Double(bounds.height)
        
        // left side
        path.move(to: CGPoint(x: 0.0, y: height - cornerRadius))
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius + arrowHeight), radius: CGFloat(cornerRadius), startAngle: Constants.straightLeft, endAngle: Constants.straightUp, clockwise: true)
        
        // arrow
        let margin = cornerRadius + arrowWidth / 2.0
        let arrowOffset = margin + (width - 2.0 * margin) * arrowPosition
        path.addLine(to: CGPoint(x: arrowOffset - arrowWidth / 2.0, y: arrowHeight))
        path.addLine(to: CGPoint(x: arrowOffset, y: 0.0))
        path.addLine(to: CGPoint(x: arrowOffset + arrowWidth / 2.0, y: arrowHeight))
        
        // top side
        path.addArc(withCenter: CGPoint(x: width - cornerRadius, y: cornerRadius + arrowHeight), radius: CGFloat(cornerRadius), startAngle: Constants.straightUp, endAngle: Constants.straightRight, clockwise: true)
        
        // right side
        path.addArc(withCenter: CGPoint(x: width - cornerRadius, y: height - cornerRadius), radius: CGFloat(cornerRadius), startAngle: Constants.straightRight, endAngle: Constants.straightDown, clockwise: true)
        
        // down side
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: height - cornerRadius), radius: CGFloat(cornerRadius), startAngle: Constants.straightDown, endAngle: Constants.straightLeft, clockwise: true)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }
}
