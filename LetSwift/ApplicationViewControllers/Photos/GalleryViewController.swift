//
//  GalleryViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 07.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class GalleryViewController: AppViewController {
    
    @IBOutlet weak var pagingScrollView: UIScrollView!
    
    fileprivate var viewModel: PhotoGalleryViewControllerViewModel!
    
    private let disposeBag = DisposeBag()
    
    override var shouldHideShadow: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden ?? false
    }
    
    convenience init(viewModel: PhotoGalleryViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.hidesBarsOnTap = false
        navigationController?.hidesBarsOnSwipe = false
    }
    
    private func setup() {
        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        //navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsOnSwipe = true
        pagingScrollView.delegate = self
    }
    
    private func setupPhotos(with photos: [Photo]) {
        let frameSize = pagingScrollView.frame.insetBy(dx: 0.0, dy: 32.0).size
        
        photos.enumerated().forEach { index, photo in
            let frame = CGRect(origin: CGPoint(x: frameSize.width * CGFloat(index), y: 0.0),
                               size: frameSize)
            
            let subview = NetworkImageView(frame: frame)
            subview.contentMode = .scaleAspectFit
            subview.imageURL = photo.big
            
            pagingScrollView.addSubview(subview)
        }
        
        pagingScrollView.contentSize = CGSize(width: frameSize.width * CGFloat(photos.count),
                                              height: frameSize.height)
    }
 
    private func setupViewModel() {
        viewModel.photosObservable.subscribeNext(startsWithInitialValue: true) { [weak self] photos in
            self?.setupPhotos(with: photos)
        }
        .add(to: disposeBag)
        
        viewModel.photoSelectedObservable.subscribeNext(startsWithInitialValue: true) { [weak self] index in
            self?.title = "\(index + 1) \(localized("PHOTOS_OF")) \(self?.viewModel.photosObservable.value.count ?? 0)"
            self?.pagingScrollView.contentOffset.x = CGFloat(index) * (self?.pagingScrollView.frame.width ?? 0.0)
        }
        .add(to: disposeBag)
    }
}

extension GalleryViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.photoSelectedObservable.next(Int(scrollView.contentOffset.x / scrollView.frame.width))
    }
}
