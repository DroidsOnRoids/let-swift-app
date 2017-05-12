//
//  CarouselEventPhotosCellViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 09.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class CarouselEventPhotosCellViewModel {

    var photosObservable = Observable<[String]>([])
    var currentPageObservable = Observable<Int>(0)
    var scrollViewSwipeDidFinishObservable = Observable<Int>(0)

    init(photos: [String]) {
        photosObservable.next(photos)

        setup()
    }

    private func setup() {
        scrollViewSwipeDidFinishObservable.subscribe(onNext: { [weak self] page in
            self?.currentPageObservable.next(page)
        })
    }
}
