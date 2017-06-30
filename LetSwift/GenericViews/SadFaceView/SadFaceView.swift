//
//  SadFaceView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 22.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SadFaceView: DesignableView, Localizable, UIScrollViewDelegate {
    
    @IBOutlet private weak var pullToRefreshLabel: UILabel!
    @IBOutlet private weak var somethingWentWrongLabel: UILabel!
    
    var scrollView: UIScrollView?

    var errorText: String? {
        set {
            somethingWentWrongLabel.text = errorText
        }
        get {
            return somethingWentWrongLabel.text
        }
    }

    var pullToRefreshText: String? {
        set {
            pullToRefreshLabel.text = pullToRefreshText
        }
        get {
            return pullToRefreshLabel.text
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
