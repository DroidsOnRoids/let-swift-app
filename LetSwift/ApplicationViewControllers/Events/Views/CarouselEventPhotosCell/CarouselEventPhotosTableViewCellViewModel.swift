//
//  CarouselEventPhotosCellViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 09.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class CarouselEventPhotosTableViewCellViewModel {

    var photosObservable = Observable<[Photo]>([])
    var currentPageObservable = Observable<Int>(0)
    var scrollViewSwipeDidFinishObservable = Observable<Int>(0)
    
    private let disposeBag = DisposeBag()

    init(photos: [Photo]) {
        photosObservable.next(photos)

        setup()
    }

    private func setup() {
        scrollViewSwipeDidFinishObservable.subscribeNext { [weak self] page in
            self?.currentPageObservable.next(page)
        }
        .add(to: disposeBag)
    }
}
