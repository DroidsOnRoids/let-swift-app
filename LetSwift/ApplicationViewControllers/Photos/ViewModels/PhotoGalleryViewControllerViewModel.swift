//
//  PhotoGalleryViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 15.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import CoreGraphics

final class PhotoGalleryViewControllerViewModel {

    let photosObservable: Observable<[Photo]>
    let photosRefreshObservable = Observable<Void>()
    let photoSelectedObservable = Observable<Int>(0)
    let targetFrameObservable = Observable<CGRect>(.zero)
    let targetVisibleClousureObservable = Observable<((Bool) -> ())?>(nil)
    let targetVisibleObservable = Observable<Bool?>(nil)
    let sliderTitleObservable = Observable<String>("")
    
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
