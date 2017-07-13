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

    fileprivate var lastContentOffset: CGFloat = 0.0
    
    private let disposeBag = DisposeBag()
    private let placeholderView = UIImageView(image: #imageLiteral(resourceName: "PhotoMock"))

    var viewModel: CarouselEventPhotosTableViewCellViewModel! {
        didSet {
            if let _ = viewModel {
                reactiveSetup()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        scrollView.delegate = self
        setupPlaceholder()
    }

    private func reactiveSetup() {
        viewModel.photosObservable.subscribeNext(startsWithInitialValue: true) { [weak self] photos in
            DispatchQueue.main.async {
                self?.setupScrollView(with: photos)
                self?.pageControl.numberOfPages = photos.count
                self?.pageControl.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
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

        images.enumerated().forEach { index, _ in
            let frame = CGRect(origin: CGPoint(x: frameSize.width * CGFloat(index), y: 0.0),
                               size: frameSize)

            let subview = UIImageView(frame: frame)
            subview.contentMode = .scaleAspectFill
            subview.clipsToBounds = true
            subview.sd_setImage(with: images[index].big) { image, _, _, _ in
                guard image == nil else { return }

                subview.image = #imageLiteral(resourceName: "PhotoMock")
            }

            scrollView.addSubview(subview)
        }

        scrollView.contentSize = CGSize(width: frameSize.width * CGFloat(images.count),
                                        height: frameSize.height)
    }

    private func setupPlaceholder() {
        placeholderView.contentMode = .scaleAspectFill
        placeholderView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(placeholderView)
        placeholderView.pinToFit(view: contentView)
        clipsToBounds = true
        placeholderView.isHidden = true
    }
}

extension CarouselEventPhotosTableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.scrollViewSwipeDidFinishObservable.next(Int(scrollView.contentOffset.x / scrollView.frame.width))
    }
}
