//
//  AppTableView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 23.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AppTableView: UITableView {
    
    var hideOverlayAnimated = true
    
    var overlayView: UIView? = nil {
        willSet {
            hideOverlayView()
        }
        didSet {
            showOverlayView()
        }
    }
    
    private func showOverlayView() {
        guard let overlayView = overlayView, let superview = superview else { return }
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(overlayView)
        
        overlayView.pinToFit(view: self, with: self.contentInset)
    }
    
    private func hideOverlayView() {
        guard let _ = overlayView, hideOverlayAnimated else { return }
        
        let oldOverlayView = overlayView
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            oldOverlayView?.alpha = 0.0
        }, completion: { completed in
            oldOverlayView?.removeFromSuperview()
        })
    }
}
