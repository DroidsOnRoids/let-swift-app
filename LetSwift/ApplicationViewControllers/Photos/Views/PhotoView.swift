//
//  PhotoView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 23.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class PhotoView: UIScrollView {
    
    override var contentInset: UIEdgeInsets {
        get {
            return .zero
        }
        set {
        }
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            let oldImage = imageView.image
            imageView.image = newValue
            
            if oldImage?.size != newValue?.size {
                updateImageView()
                oldSize = nil
            }
        }
    }
    
    fileprivate let imageView = UIImageView()
    
    private var oldSize: CGSize?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(image: UIImage) {
        super.init(frame: CGRect.zero)
        self.image = image
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let _ = imageView.image && oldSize != bounds.size {
            updateImageView()
            oldSize = bounds.size
        }
        
        if imageView.frame.width <= bounds.width {
            imageView.center.x = bounds.width * 0.5
        }
        
        if imageView.frame.height <= bounds.height {
            imageView.center.y = bounds.height * 0.5
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        updateImageView()
    }
    
    private func setup() {
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        zoomScale = 1.0
        maximumZoomScale = 4.0
        
        addSubview(imageView)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
    }
    
    private func scrollToCenter() {
        let centerOffset = CGPoint(
            x: (contentSize.width / 2.0) - (bounds.width / 2.0),
            y: (contentSize.height / 2.0) - (bounds.height / 2.0)
        )
        
        contentOffset = centerOffset
    }
    
    private func updateImageView() {
        guard let image = imageView.image else { return }
        
        let widthRatio = (bounds.size.width / image.size.width)
        let heightRatio = (bounds.size.height / image.size.height)
        
        var boundingSize = bounds.size
        
        if widthRatio < heightRatio {
            boundingSize.height = boundingSize.width / image.size.width * image.size.height
        } else if heightRatio < widthRatio {
            boundingSize.width = boundingSize.height / image.size.height * image.size.width
        }
        
        contentSize = CGSize(width: ceil(boundingSize.width), height: ceil(boundingSize.height))
        
        imageView.bounds.size = contentSize
        imageView.center = contentCenter(for: bounds.size, contentSize: contentSize)
    }
    
    fileprivate func contentCenter(for boundingSize: CGSize, contentSize: CGSize) -> CGPoint {
        let horizontalOffest = (boundingSize.width > contentSize.width) ? ((boundingSize.width - contentSize.width) * 0.5) : 0.0
        let verticalOffset = (boundingSize.height > contentSize.height) ? ((boundingSize.height - contentSize.height) * 0.5) : 0.0
        
        return CGPoint(x: contentSize.width * 0.5 + horizontalOffest, y: contentSize.height * 0.5 + verticalOffset)
    }
    
    @objc private func handleDoubleTap() {
        setZoomScale(zoomScale == 1.0 ? 2.0 : 1.0, animated: true)
    }
}

extension PhotoView: UIScrollViewDelegate {
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = contentCenter(for: bounds.size, contentSize: contentSize)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
