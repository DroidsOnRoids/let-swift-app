//
//  SizedScrollView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class SizedScrollView: UIScrollView {
    
    override var frame: CGRect {
        didSet {
            notifySizeChangeIfNecessary()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            notifySizeChangeIfNecessary()
        }
    }
    
    private var lastSize: CGSize = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lastSize = frame.size
        
        if lastSize != .zero {
            sizeHasChanged(to: lastSize)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func sizeHasChanged(to size: CGSize) {
    }
    
    private func notifySizeChangeIfNecessary() {
        if lastSize != bounds.size {
            lastSize = bounds.size
            sizeHasChanged(to: lastSize)
        }
    }
}
