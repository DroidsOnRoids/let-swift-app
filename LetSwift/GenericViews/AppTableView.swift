//
//  AppTableView.swift
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

final class AppTableView: UITableView {
    
    var hideOverlayAnimated = true
    var childAutomaticallyUpdatesContentInset = false
    
    var overlayView: UIView? {
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
        
        overlayView.pinToFit(view: self,
                             with: childAutomaticallyUpdatesContentInset ? .zero : contentInset)
    }
    
    private func hideOverlayView() {
        guard let _ = overlayView, hideOverlayAnimated else { return }
        
        let oldOverlayView = overlayView
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            oldOverlayView?.alpha = 0.0
        }, completion: { _ in
            oldOverlayView?.removeFromSuperview()
        })
    }
}
