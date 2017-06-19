//
//  PhotoView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class PhotoView: SizedScrollView {
    
    override var contentInset: UIEdgeInsets {
        get {
            return .zero
        }
        set {
        }
    }
    
    fileprivate var imageView: UIImageView?
    
    private var subviewBottomConstraint: NSLayoutConstraint?
    private var subviewLeadingConstraint: NSLayoutConstraint?
    private var subviewTopConstraint: NSLayoutConstraint?
    private var subviewTrailingConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func sizeHasChanged(to size: CGSize) {
        updateMinZoomScaleForSize(size)
    }
    
    func display(image: UIImage) {
        imageView?.removeFromSuperview()
        imageView = UIImageView(image: image)
        
        if let imageView = imageView {
            addSubview(imageView)
            constraintToFit(imageView)
            updateMinZoomScaleForSize(bounds.size)
        }
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        guard let imageView = imageView else { return }
        
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        subviewTopConstraint?.constant = yOffset
        subviewBottomConstraint?.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        subviewLeadingConstraint?.constant = xOffset
        subviewTrailingConstraint?.constant = xOffset
        
        layoutIfNeeded()
    }
    
    private func setup() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        
        setupTapRecognizer()
    }
    
    private func setupTapRecognizer() {
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapRecognized))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
    }
    
    private func constraintToFit(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        subviewBottomConstraint = view.bottomAnchor.constraint(equalTo: bottomAnchor)
        subviewLeadingConstraint = view.leadingAnchor.constraint(equalTo: leadingAnchor)
        subviewTopConstraint = view.topAnchor.constraint(equalTo: topAnchor)
        subviewTrailingConstraint = view.trailingAnchor.constraint(equalTo: trailingAnchor)
        
        subviewBottomConstraint?.isActive = true
        subviewLeadingConstraint?.isActive = true
        subviewTopConstraint?.isActive = true
        subviewTrailingConstraint?.isActive = true
    }
    
    private func updateMinZoomScaleForSize(_ size: CGSize) {
        guard let imageView = imageView else { return }
        
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        minimumZoomScale = minScale
        zoomScale = minScale
    }
    
    @objc private func doubleTapRecognized(sender: UITapGestureRecognizer) {
        if zoomScale == minimumZoomScale {
            setZoomScale(minimumZoomScale * 2.0, animated: true)
        } else {
            setZoomScale(minimumZoomScale, animated: true)
        }
    }
}

extension PhotoView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(bounds.size)
    }
}
