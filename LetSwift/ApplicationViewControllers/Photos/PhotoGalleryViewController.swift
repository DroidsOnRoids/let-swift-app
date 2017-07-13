//
//  PhotosViewController.swift
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

import UIKit

protocol PhotoGalleryViewControllerDelegate: class {
    func presentPhotoSliderScreen(with viewModel: PhotoGalleryViewControllerViewModel)
}

final class PhotoGalleryViewController: AppViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    fileprivate var viewModel: PhotoGalleryViewControllerViewModel!
    
    private let disposeBag = DisposeBag()
    
    override var viewControllerTitleKey: String? {
        return "PHOTOS_TITLE"
    }
    
    override var shouldHideShadow: Bool {
        return true
    }

    fileprivate var columnNumber: Int {
        return DeviceScreenHeight.deviceHeight > DeviceScreenHeight.inch4¨7 ? 3 : 2
    }
    
    convenience init(viewModel: PhotoGalleryViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func setNeedsStatusBarAppearanceUpdate() {
        super.setNeedsStatusBarAppearanceUpdate()

        navigationController?.isNavigationBarHidden = true
        navigationController?.isNavigationBarHidden = false
    }

    private func setup() {
        collectionView.registerCells([SinglePhotoCollectionViewCell.self])
        collectionView.delegate = self
        
        setupPullToRefresh()
        reactiveSetup()
    }
    
    private func setupPullToRefresh() {
        collectionView.addPullToRefresh { [weak self] in
            self?.viewModel.photosRefreshObservable.next()
        }
        
        viewModel.photosRefreshObservable.subscribeCompleted { [weak self] in
            self?.collectionView.finishPullToRefresh()
        }
        .add(to: disposeBag)
    }
    
    private func reactiveSetup() {
        viewModel.photosObservable.subscribeNext(startsWithInitialValue: true) { [weak self] photos in
            guard let weakSelf = self else { return }
            
            photos.bindable.bind(to: weakSelf.collectionView.items() ({ collectionView, index, element in
                let indexPath = IndexPath(row: index, section: 0)
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SinglePhotoCollectionViewCell.cellIdentifier, for: indexPath) as! SinglePhotoCollectionViewCell
                cell.imageURL = element.thumb
                
                return cell
            }))
        }
        .add(to: disposeBag)
        
        viewModel.photoSelectedObservable.subscribeNext { [weak self] index in
            let indexPath = IndexPath(row: index, section: 0)
            guard let weakSelf = self, let cellView = weakSelf.collectionView.cellForItem(at: indexPath) else { return }
            
            weakSelf.collectionView.scrollToShow(itemAt: indexPath, animated: true)
            
            weakSelf.viewModel.targetVisibleClousureObservable.next { hidden in
                cellView.isHidden = hidden

                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2) {
                        self?.setNeedsStatusBarAppearanceUpdate()
                    }
                }
            }
            
            weakSelf.viewModel.targetFrameObservable.next {
                return weakSelf.collectionView.convert(cellView.frame, to: nil)
            }
        }
        .add(to: disposeBag)
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0.0
        let cellPadding = itemSpacing * CGFloat(columnNumber + 1)
        let cellSize = (collectionView.bounds.width - cellPadding) / CGFloat(columnNumber)
        
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.photoSelectedObservable.next(indexPath.row)
        viewModel.photoSelectedObservable.complete()
    }
}
