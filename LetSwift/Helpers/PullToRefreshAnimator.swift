//
//  PullToRefreshAnimator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 23.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import ESPullToRefresh

final class PullToRefreshAnimator: UIView, ESRefreshAnimatorProtocol {
    
    var view: UIView { return self }
    var insets: UIEdgeInsets = .zero
    var trigger: CGFloat = 55.0
    var executeIncremental: CGFloat = 55.0
    var state: ESRefreshViewState = .pullToRefresh
    
    let spinnerView = SpinnerView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        spinnerView.frame.size = CGSize(width: 19, height: 19)
        spinnerView.image = #imageLiteral(resourceName: "WhiteSpinner")
        spinnerView.backgroundColor = .clear

        addSubview(spinnerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        spinnerView.center = center
    }
}

extension PullToRefreshAnimator: ESRefreshProtocol {
    func refreshAnimationBegin(view: ESRefreshComponent) {
    }
    
    func refreshAnimationEnd(view: ESRefreshComponent) {
    }
    
    func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
    }
    
    func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
    }
}
