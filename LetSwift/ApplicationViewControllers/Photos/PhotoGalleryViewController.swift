//
//  PhotosViewController.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 15.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol PhotoGalleryViewControllerDelegate: class {
}

final class PhotoGalleryViewController: AppViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // TODO: private
    fileprivate var viewModel: PhotoGalleryViewControllerViewModel!
    
    private let disposeBag = DisposeBag()
    
    override var viewControllerTitleKey: String? {
        return "PHOTOS_TITLE"
    }
    
    override var shouldHideShadow: Bool {
        return true
    }
    
    fileprivate var columnNumber: Int {
        return DeviceScreenHeight.deviceHeight > DeviceScreenHeight.inch4¨7.rawValue ? 3 : 2
    }
    
    convenience init(viewModel: PhotoGalleryViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        collectionView.registerCells([SinglePhotoCell.self])
        collectionView.delegate = self
        
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel.photosObservable.subscribeNext(startsWithInitialValue: true) { [weak self] photos in
            guard let weakSelf = self else { return }
            
            photos.bindable.bind(to: weakSelf.collectionView.items() ({ collectionView, index, element in
                let indexPath = IndexPath(row: index, section: 0)
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SinglePhotoCell.cellIdentifier, for: indexPath) as! SinglePhotoCell
                cell.imageURL = element.thumb
                
                return cell
            }))
        }
        .add(to: disposeBag)
        
        // TODO: It should be done this way...
//        collectionView.itemDidSelectObservable.subscribeNext { [weak self] indexPath in
//            self?.viewModel.photoSelectedObservable.next(indexPath.item)
//        }
//        .add(to: disposeBag)
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0.0
        let cellPadding = itemSpacing * CGFloat(columnNumber + 1)
        let cellSize = (collectionView.bounds.width - cellPadding) / CGFloat(columnNumber)
        
        return CGSize(width: cellSize, height: cellSize)
    }
    
    // TODO: ...not this way
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.photoSelectedObservable.next(indexPath.item)
    }
}
