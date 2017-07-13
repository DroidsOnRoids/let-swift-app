//
//  PullToRefreshAnimator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 23.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
