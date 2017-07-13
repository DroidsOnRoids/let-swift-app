//
//  CarouselEventPhotosTableViewCellViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 09.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
