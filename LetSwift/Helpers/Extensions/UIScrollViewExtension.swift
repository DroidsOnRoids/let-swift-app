//
//  UIScrollViewExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 27.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UIScrollView {
    func addPullToRefresh(callback: @escaping () -> ()) {
        es_addPullToRefresh(animator: PullToRefreshAnimator(), handler: callback)
    }

    func removePullToRefresh() {
        es_removeRefreshHeader()
    }
    
    func finishPullToRefresh() {
        es_stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
    }
}
