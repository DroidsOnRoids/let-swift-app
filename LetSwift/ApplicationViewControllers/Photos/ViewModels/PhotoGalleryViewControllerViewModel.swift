//
//  PhotoGalleryViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 15.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class PhotoGalleryViewControllerViewModel {

    let photosObservable: Observable<[Photo]>
    let photoSelectedObservable = Observable<Int>(0)

    weak var delegate: PhotoGalleryViewControllerDelegate?
    
    private let disposeBag = DisposeBag()

    init(photos: [Photo], delegate: PhotoGalleryViewControllerDelegate?) {
        photosObservable = Observable<[Photo]>(photos)
        self.delegate = delegate
        
        setup()
    }
    
    private func setup() {
        photoSelectedObservable.subscribeCompleted { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.presentGallery(with: weakSelf)
        }
        .add(to: disposeBag)
    }
}
