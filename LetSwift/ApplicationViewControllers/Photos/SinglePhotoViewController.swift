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
    
    private var photoView: PhotoView!
    private var spinner: DACircularProgressView!
    
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
        photoView = PhotoView()
        photoView.isHidden = true
        
        photoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoView)
        
        photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupSpinner() {
        spinner = DACircularProgressView()
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
        SDWebImageManager.shared().downloadImage(with: photo?.big, options: SDWebImageOptions(rawValue: 0), progress: { [weak self] (received, expected) in
            let progress = Float(received) / Float(expected)
            self?.spinner.progress = CGFloat(progress)
        }, completed: { [weak self] (image, _, _, _, _) in
            if let image = image {
                self?.photoView.display(image: image)
            }
            
            self?.spinner.isHidden = true
            self?.photoView.isHidden = false
        })
    }
}
