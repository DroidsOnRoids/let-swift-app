//
//  SinglePhotoViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import DACircularProgress
import SDWebImage

final class SinglePhotoViewController: UIViewController {
    
    private enum Constants {
        static let spinnerSize: CGFloat = 45.0
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
    
    private var photoView = PhotoView()
    private var spinner = DACircularProgressView()
    
    private var photo: Photo?
    
    convenience init(photo: Photo) {
        self.init()
        self.photo = photo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupPhotoView()
        setupSpinner()
        download()
    }
    
    private func setupPhotoView() {
        photoView.isHidden = true
        
        photoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoView)
        
        photoView.pinToFit(view: view)
    }
    
    private func setupSpinner() {
        spinner.thicknessRatio = 0.25
        spinner.trackTintColor = .paleGrey
        spinner.progressTintColor = .swiftOrange
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: Constants.spinnerSize).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: Constants.spinnerSize).isActive = true
    }
    
    private func download() {
        SDWebImageManager.shared().downloadImage(with: photo?.big, options: [], progress: { [weak self] received, expected in
            let progress = CGFloat(received) / CGFloat(expected)
            self?.spinner.progress = progress
        }, completed: { [weak self] image, _, _, _, _ in
            if let image = image {
                self?.photoView.display(image: image)
            }
            
            self?.spinner.isHidden = true
            self?.photoView.isHidden = false
        })
    }
}
