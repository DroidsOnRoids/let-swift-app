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
    let mwPhotosObservable = Observable<[MWPhoto]>([])
    let photoSelectedObservable = Observable<Int>(0)
    
    private let disposeBag = DisposeBag()

    init(photos: [Photo]) {
        photosObservable = Observable<[Photo]>(photos)
        
        setup()
    }
    
    private func setup() {
        photosObservable.subscribeNext(startsWithInitialValue: true) { [weak self] photos in
            self?.mwPhotosObservable.next(photos.map { MWPhoto(url: $0.big) })
        }
        .add(to: disposeBag)
    }
}
