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
    
    override var viewControllerTitleKey: String? {
        return "PHOTOS_TITLE"
    }
    
    override var shouldHideShadow: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerCells([SinglePhotoCell.self])
        collectionView.delegate = self
        
        [0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5]
            .bindable.bind(to: collectionView.items() ({ collectionView, index, element in
            let indexPath = IndexPath(row: index, section: 0)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SinglePhotoCell.cellIdentifier, for: indexPath) as! SinglePhotoCell
            
            return cell
            
            /*if let event = element {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviousEventCell.cellIdentifier, for: indexPath) as! PreviousEventCell
                cell.title = event.title
                cell.date = event.date?.stringDateValue
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.cellIdentifier, for: indexPath) as! LoadingCollectionViewCell
                cell.animateSpinner()
                
                return cell
            }*/
        }))
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0.0
        let cellPadding = itemSpacing * CGFloat(columnNumber + 1)
        let cellSize = (collectionView.bounds.width - cellPadding) / CGFloat(columnNumber)
        
        return CGSize(width: cellSize, height: cellSize)
    }
    
    private var columnNumber: Int {
        return DeviceScreenHeight.deviceHeight > DeviceScreenHeight.inch4¨7.rawValue ? 3 : 2
    }
}
