//
//  PullToRefreshAnimator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 23.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import ESPullToRefresh

final class PullToRefreshAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {
    
    var view: UIView { return self }
    var insets: UIEdgeInsets = .zero
    var trigger: CGFloat = 55.0
    var executeIncremental: CGFloat = 55.0
    var state: ESRefreshViewState = .pullToRefresh
    
    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        
        addSubview(indicatorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorView.center = center
    }
    
    func refreshAnimationBegin(view: ESRefreshComponent) {
    }
    
    func refreshAnimationEnd(view: ESRefreshComponent) {
    }
    
    func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
    }
    
    func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
    }
}
