//
//  CarouselEventPhotosCell.swift
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

import UIKit

final class CarouselEventPhotosTableViewCell: UITableViewCell {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    private let placeholderView = UIImageView(image: #imageLiteral(resourceName: "EventPlaceholder"))
    private let disposeBag = DisposeBag()

    var viewModel: CarouselEventPhotosTableViewCellViewModel! {
        didSet {
            if let _ = viewModel {
                reactiveSetup()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func reactiveSetup() {
        viewModel.photosObservable.subscribeNext(startsWithInitialValue: true) { [weak self] photos in
            self?.setupScrollView(with: photos)
            self?.pageControl.numberOfPages = photos.count
        }
        .add(to: disposeBag)

        viewModel.currentPageObservable.subscribeNext { [weak self] page in
            self?.pageControl.currentPage = page
        }
        .add(to: disposeBag)
    }

    private func setupScrollView(with images: [Photo]) {
        placeholderView.isHidden = !images.isEmpty
        
        let frameSize = scrollView.frame.size
        
        scrollView.subviews.forEach { $0.removeFromSuperview() }

        images.enumerated().forEach { index, _ in
            let frame = CGRect(origin: CGPoint(x: frameSize.width * CGFloat(index), y: 0.0),
                               size: frameSize)

            let subview = UIImageView(frame: frame)
            subview.contentMode = .scaleAspectFill
            subview.clipsToBounds = true
            subview.setImage(url: images[index].big, errorPlaceholder: #imageLiteral(resourceName: "EventPlaceholder"))
            
            scrollView.addSubview(subview)
        }

        scrollView.contentSize = CGSize(width: frameSize.width * CGFloat(images.count),
                                        height: frameSize.height)
    }
    
    private func setup() {
        scrollView.delegate = self
        
        pageControl.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        pageControl.currentPageIndicatorTintColor = .brandingColor
        
        placeholderView.contentMode = .scaleAspectFill
        placeholderView.clipsToBounds = true
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.isHidden = true
        contentView.addSubview(placeholderView)
        placeholderView.pinToFit(view: contentView)
    }
}

extension CarouselEventPhotosTableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.currentPageObservable.next(Int(scrollView.contentOffset.x / scrollView.frame.width))
    }
}
