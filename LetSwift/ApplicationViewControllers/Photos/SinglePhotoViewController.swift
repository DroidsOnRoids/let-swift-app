//
//  SinglePhotoViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.06.2017.
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
import DACircularProgress
import SDWebImage

final class SinglePhotoViewController: UIViewController {
    
    private enum Constants {
        static let centerItemSize: CGFloat = 45.0
    }
    
    var canDismissInteractively: Bool {
        return photoView.zoomScale == 1.0
    }
    
    var scaleToFill = false {
        didSet {
            if scaleToFill {
                let width = photoView.contentSize.width
                let height = photoView.contentSize.height
                let ratio = max(width, height) / min(width, height)
                
                photoView.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            } else {
                photoView.transform = .identity
            }
        }
    }
    
    private var contentState: AppContentState? {
        didSet {
            guard let contentState = contentState else { return }
            switch contentState {
            case .content:
                photoView.isHidden = false
                errorView.isHidden = true
                spinnerView.isHidden = true
            case .error:
                photoView.isHidden = true
                errorView.isHidden = false
                spinnerView.isHidden = true
            case .loading:
                photoView.isHidden = true
                errorView.isHidden = true
                spinnerView.isHidden = false
            }
        }
    }
    
    private let photoView: PhotoView = {
        let photoView = PhotoView()
        photoView.translatesAutoresizingMaskIntoConstraints = false
        
        return photoView
    }()
    
    private let errorView: UIImageView = {
        let errorView = UIImageView(image: #imageLiteral(resourceName: "GalleryError"))
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        return errorView
    }()
    
    private let spinnerView: DACircularProgressView = {
        let spinnerView = DACircularProgressView()
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.thicknessRatio = 0.25
        spinnerView.trackTintColor = .paleGrey
        spinnerView.progressTintColor = .swiftOrange
        
        return spinnerView
    }()
    
    private var photo: Photo?
    
    convenience init(photo: Photo) {
        self.init()
        self.photo = photo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        download()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        photoView.zoomScale = 1.0
    }
    
    private func setup() {
        [photoView, errorView, spinnerView].forEach(view.addSubview)
        
        photoView.pinToFit(view: view)
        errorView.pinToCenter(view: view, width: Constants.centerItemSize, height: Constants.centerItemSize)
        spinnerView.pinToCenter(view: view, width: Constants.centerItemSize, height: Constants.centerItemSize)
    }
    
    private func download() {
        contentState = .loading
        SDWebImageManager.shared().loadImage(with: photo?.big, options: [], progress: { [weak self] received, expected, _ in
            let progress = CGFloat(received) / CGFloat(expected)
            self?.spinnerView.progress = progress
        }, completed: { [weak self] image, _, _, _, _, _ in
            if let image = image {
                self?.photoView.image = image
                self?.contentState = .content
            } else {
                self?.contentState = .error
            }
        })
    }
}
