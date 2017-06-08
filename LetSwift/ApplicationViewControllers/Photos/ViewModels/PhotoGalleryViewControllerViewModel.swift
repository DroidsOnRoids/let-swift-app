//
//  PhotoGalleryViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 15.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class PhotoGalleryViewControllerViewModel {

    let photosObservable: Observable<[Photo]>
    let photoSelectedObservable = Observable<Int>(-1)

    weak var delegate: PhotoGalleryViewControllerDelegate?
    
    private let disposeBag = DisposeBag()

    init(photos: [Photo], delegate: PhotoGalleryViewControllerDelegate?) {
        photosObservable = Observable<[Photo]>(photos)
        self.delegate = delegate
        
        setup()
    }
    
    private func setup() {
        photoSelectedObservable.subscribeNext { [weak self] index in
            guard let photo = self?.photosObservable.value[index] else { return }
            // TODO: do something with photo
            print(photo)
        }
        .add(to: disposeBag)
    }
}
