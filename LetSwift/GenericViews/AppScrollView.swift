//
//  AppScrollView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 05.07.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AppScrollView: UIScrollView {
    
    override var contentOffset: CGPoint {
        didSet {
            contentOffsetObservable.next(contentOffset)
        }
    }
    
    let contentOffsetObservable = Observable<CGPoint>(.zero)
}
