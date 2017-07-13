//
//  PhotoGalleryViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 15.05.2017.
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

import CoreGraphics

final class PhotoGalleryViewControllerViewModel {

    let photosObservable: Observable<[Photo]>
    let photosRefreshObservable = Observable<Void>()
    let photoSelectedObservable = Observable<Int>(0)
    let targetFrameObservable = Observable<(() -> CGRect)?>(nil)
    let targetVisibleClousureObservable = Observable<((Bool) -> ())?>(nil)
    let targetVisibleObservable = Observable<Bool?>(nil)
    let sliderTitleObservable = Observable<String>("")
    let lastNaviagtionBarHiddenObservable = Observable<Bool>(false)
    let restoreNaviationBarVisibilityObservable = Observable<Bool>(false)
    
    weak var delegate: PhotoGalleryViewControllerDelegate?
    
    private let disposeBag = DisposeBag()
    private let eventDetailsId: Int?

    init(photos: [Photo], eventId: Int?, delegate: PhotoGalleryViewControllerDelegate?) {
        photosObservable = Observable<[Photo]>(photos)
        eventDetailsId = eventId
        self.delegate = delegate
        
        setup()
    }
    
    private func setup() {
        photosRefreshObservable.subscribeNext { [weak self] in
            self?.refreshPhotosFromEvent()
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
        
        targetVisibleObservable.subscribeNext { [weak self] hidden in
            guard let hidden = hidden else { return }
            self?.targetVisibleClousureObservable.value?(hidden)
        }
        .add(to: disposeBag)

        restoreNaviationBarVisibilityObservable.subscribeCompleted { [weak self] in
            guard let weakSelf = self else { return }

            weakSelf.lastNaviagtionBarHiddenObservable.next(weakSelf.restoreNaviationBarVisibilityObservable.value)
        }
        .add(to: disposeBag)
    }
    
    private func refreshPhotosFromEvent() {
        guard let eventDetailsId = eventDetailsId else { return }
        NetworkProvider.shared.eventDetails(with: eventDetailsId) { [weak self] response in
            if case .success(let event) = response {
                self?.photosObservable.next(event.photos)
            }
            
            self?.photosRefreshObservable.complete()
        }
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
