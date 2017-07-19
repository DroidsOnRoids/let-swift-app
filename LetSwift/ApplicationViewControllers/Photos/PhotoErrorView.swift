//
//  PhotoErrorView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 12.07.2017.
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

final class PhotoErrorView: UIView {
    
    private enum Constants {
        static let errorImageSize: CGFloat = 45.0
        static let sadFaceSize: CGFloat = 126.0
        static let cryingInterval = 0.5
        static let tapsToActivate = 10
    }
    
    private var rightEye = true
    private var timer: Timer?
    
    private var tearDropView: UIView {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 20.0))
        let width = Double(view.bounds.width)
        let height = Double(view.bounds.height)
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: width / 2.0, y: 0.0))
        path.addQuadCurve(to: CGPoint(x: width / 2.0, y: height), controlPoint: CGPoint(x: width, y: height))
        path.addQuadCurve(to: CGPoint(x: width / 2.0, y: 0.0), controlPoint: CGPoint(x: 0.0, y: height))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        view.layer.mask = shapeLayer
        view.backgroundColor = .lightBlueGrey
        
        return view
    }
    
    private let errorImageView: UIImageView = {
        let errorImageView = UIImageView(image: #imageLiteral(resourceName: "GalleryError"))
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return errorImageView
    }()
    
    private let sadFaceImageView: UIImageView = {
        let sadFaceImageView = UIImageView(image: #imageLiteral(resourceName: "SadFace"))
        sadFaceImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return sadFaceImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview == nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func setup() {
        [errorImageView, sadFaceImageView].forEach(addSubview)
        
        errorImageView.pinToCenter(view: self, width: Constants.errorImageSize, height: Constants.errorImageSize)
        sadFaceImageView.pinToCenter(view: self, width: Constants.sadFaceSize, height: Constants.sadFaceSize)
        
        errorImageView.isHidden = false
        sadFaceImageView.isHidden = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.numberOfTapsRequired = Constants.tapsToActivate
        addGestureRecognizer(gestureRecognizer)
    }
    
    private func startCrying() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: Constants.cryingInterval, target: self, selector: #selector(cry), userInfo: nil, repeats: true)
    }

    @objc private func cry() {
        let tear = tearDropView
        let xOffset = sadFaceImageView.center.x + (rightEye ? 24.0 : -17.0)
        tear.center = CGPoint(x: xOffset, y: sadFaceImageView.center.y - 8.0)
        rightEye = !rightEye
        addSubview(tear)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            tear.frame.origin.y = self.frame.maxY
        }, completion: { _ in
            tear.removeFromSuperview()
        })
    }
    
    @objc private func handleTap() {
        errorImageView.isHidden = true
        sadFaceImageView.isHidden = false
        
        startCrying()
    }
}
