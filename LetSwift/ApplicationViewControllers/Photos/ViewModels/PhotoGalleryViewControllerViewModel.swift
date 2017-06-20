//
//  PhotoGalleryViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 15.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import MWPhotoBrowser

final class PhotoGalleryViewControllerViewModel {

    let photosObservable: Observable<[Photo]>
    let photoSelectedObservable = Observable<Int>(0)
    let targetFrameObservable = Observable<CGRect>(.zero)
    let sliderTitleObservable = Observable<String>("")
    
    weak var delegate: PhotoGalleryViewControllerDelegate?
    
    private let disposeBag = DisposeBag()

    init(photos: [Photo], delegate: PhotoGalleryViewControllerDelegate?) {
        photosObservable = Observable<[Photo]>(photos)
        self.delegate = delegate
        
        setup()
    }
    
    private func setup() {
        photosObservable.subscribeNext { [weak self] index in
            self?.updateSliderTitle()
        }
        .add(to: disposeBag)
        
        photoSelectedObservable.subscribeNext(startsWithInitialValue: true) { [weak self] index in
            self?.updateSliderTitle()
        }
        .add(to: disposeBag)
        
        photoSelectedObservable.subscribeCompleted { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.presentPhotoSliderScreen(with: weakSelf)
        }
        .add(to: disposeBag)
    }
    
    private func updateSliderTitle() {
        let currentIndex = photoSelectedObservable.value + 1
        let middleText = localized("PHOTOS_OF")
        let photosCount = photosObservable.value.count
        
        let newTitle = "\(currentIndex) \(middleText) \(photosCount)"
        if sliderTitleObservable.value != newTitle {
            sliderTitleObservable.next(newTitle)
        }
    }
}
