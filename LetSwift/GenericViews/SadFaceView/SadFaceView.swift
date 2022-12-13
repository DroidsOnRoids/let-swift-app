//
//  SadFaceView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 22.05.2017.
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

final class SadFaceView: DesignableView, Localizable, UIScrollViewDelegate {
    
    @IBOutlet private weak var pullToRefreshLabel: UILabel!
    @IBOutlet private weak var somethingWentWrongLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
    
    var scrollView: UIScrollView?

    var errorText: String? {
        get {
            return somethingWentWrongLabel.text
        }
        set {
            somethingWentWrongLabel.text = newValue
        }
    }

    var pullToRefreshText: String? {
        get {
            return pullToRefreshLabel.text
        }
        set {
            pullToRefreshLabel.text = newValue
        }
    }

    var isPullToRefreshVisible: Bool = true {
        didSet {
            arrowImageView.isHidden = !isPullToRefreshVisible
            pullToRefreshLabel.isHidden = !isPullToRefreshVisible
            scrollView?.isScrollEnabled = isPullToRefreshVisible
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        scrollView = subviews.first as? UIScrollView
        scrollView?.delegate = self
        
        pullToRefreshLabel.textColor = .brandingColor
        
        setupLocalization()
    }
    
    func setupLocalization() {
        pullToRefreshText = localized("GENERAL_PULL_TO_REFRESH").uppercased()
        errorText = localized("GENERAL_SOMETHING_WENT_WRONG")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxContentOffset = scrollView.contentInset.bottom
        
        if scrollView.contentOffset.y > maxContentOffset {
            scrollView.contentOffset.y = maxContentOffset
        }
    }
}
