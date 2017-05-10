//
//  CarouselEventPhotosCellViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 09.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class CarouselEventPhotosCellViewModel {

    var photosObservable = Observable<[String]>([])
    var currentPageObservable = Observable<Int>(0)

    init(photos: [String]) {
        self.photosObservable.next(photos)

        setup()
    }

    private func setup() {
    }
}
