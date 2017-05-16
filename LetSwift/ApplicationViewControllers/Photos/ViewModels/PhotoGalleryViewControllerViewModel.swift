//
//  PhotoGalleryViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 15.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class PhotoGalleryViewControllerViewModel {

    let photosObservable: Observable<[Photo]>

    var delegate: PhotoGalleryViewControllerDelegate?

    init(photos: [Photo], delegate: PhotoGalleryViewControllerDelegate?) {
        photosObservable = Observable<[Photo]>(photos)

        self.delegate = delegate
    }
}
