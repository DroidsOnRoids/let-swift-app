//
//  ReflectiveShadowView.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import CoreGraphics

class ReflectionShadowView: UIView {
    
    @IBInspectable var blurRadius: CGFloat = 10.0 {
        didSet {
            blurImage()
        }
    }
    
    @IBInspectable var blurPercentageSize: CGFloat = 0.3 {
        didSet {
            blurImage()
        }
    }
    
    @IBInspectable var blurOffsetX: CGFloat = 0.3 {
        didSet {
            blurImage()
        }
    }
    
    @IBInspectable var blurOffsetY: CGFloat = 0.3 {
        didSet {
            blurImage()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            imageView?.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var image: UIImage? {
        set {
            imageView?.image = newValue
            blurImage()
        }
        get {
            return imageView?.image
        }
    }
    
    var imageView: UIImageView!
    var shadowImageView: UIImageView!
    
    var imageSize: CGSize {
        if contentMode == .scaleAspectFit {
            guard let image = imageView.image else {
                return frame.size
            }
            let widthRatio = imageView.bounds.size.width / image.size.width
            let heightRatio = imageView.bounds.size.height / image.size.height
            let scale = min(widthRatio, heightRatio)
            let imageWidth = scale * image.size.width
            let imageHeight = scale * image.size.height
            return CGSize(width: imageWidth, height: imageHeight)
        } else {
            return frame.size
        }
    }
    
    func blurImage() {
        if let imageToblur = image,
            let resizedImage = imageToblur.resized(with: blurPercentageSize),
            let ciimage = CIImage(image: resizedImage),
            let blurredImage = appendBlur(ciimage: ciimage) {
            
            DispatchQueue.main.async {
                self.shadowImageView?.image = blurredImage
            }
        }
    }
    
    func appendBlur(ciimage : CIImage) -> UIImage? {
        
        if let filter = CIFilter(name: "CIGaussianBlur") {
            
            filter.setValue(ciimage, forKey: kCIInputImageKey)
            filter.setValue(blurRadius, forKey: kCIInputRadiusKey)
            
            let context = CIContext(options: [:])
            if let output = filter.outputImage,
                let cgimg = context.createCGImage(output, from: ciimage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = bounds
        layoutShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setShadow()
    }
    
    init(image: UIImage) {
        let frame: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        super.init(frame: frame)
        
        setShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setShadow()
    }
    
    
    private func setShadow() {
        
        imageView = UIImageView()
        imageView?.layer.masksToBounds = true
        shadowImageView = UIImageView()
        blurImage()
        addSubview(shadowImageView!)
        addSubview(imageView!)
        imageView?.contentMode = contentMode
        shadowImageView?.contentMode = contentMode
    }
    
    private func layoutShadow() {
        guard let shadowImageView = shadowImageView else { return }
        var newBounds = CGRect.zero
        newBounds.size.width = imageSize.width + imageSize.width * blurOffsetX
        newBounds.size.height = imageSize.height + imageSize.height * blurOffsetY
        
        shadowImageView.frame = newBounds
        shadowImageView.center = imageView.center
        shadowImageView.center.y = imageView.center.y + imageSize.height * 0.06
        
        let mask = CALayer()
        mask.contents = UIImage(named: "shadowMask")?.cgImage
        mask.frame =  shadowImageView.bounds
        
        shadowImageView.layer.mask = mask
        shadowImageView.layer.masksToBounds = true
    }
}

extension UIImage {
    func resized(with percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
