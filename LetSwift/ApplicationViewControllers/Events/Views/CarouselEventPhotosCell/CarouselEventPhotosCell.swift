//
//  CarouselEventPhotosCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 09.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class CarouselEventPhotosCell: UITableViewCell {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!

    fileprivate var lastContentOffset: CGFloat = 0.0

    var viewModel: CarouselEventPhotosCellViewModel! {
        didSet {
            if viewModel != nil {
                reactiveSetup()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        scrollView.delegate = self
    }

    private func reactiveSetup() {
        viewModel.photosObservable.subscribe(startsWithInitialValue: true)  { [weak self] photos in
            DispatchQueue.main.async {
                self?.setupScrollView(with: photos)
                self?.pageControl.numberOfPages = photos.count
            }
        }

        viewModel.currentPageObservable.subscribe(onNext: { [weak self] page in
            guard let weakSelf = self else { return }
            let xOffset = weakSelf.scrollView.contentOffset.x
            let singleWidth = weakSelf.scrollView.frame.width

            if xOffset >= 0.0 {
                let xPosition = CGFloat(page) * singleWidth

                weakSelf.scrollView.setContentOffset(CGPoint(x: xPosition, y: 0.0), animated: true)
                weakSelf.pageControl.currentPage = page
            }
        })
    }

    private func setupScrollView(with images: [String]) {
        let frameSize = scrollView.frame.size

        images.enumerated().forEach { index, card in
            let frame = CGRect(origin: CGPoint(x: frameSize.width * CGFloat(index), y: 0.0),
                               size: frameSize)

            let subview = UIImageView(frame: frame)
            subview.image = #imageLiteral(resourceName: "PhotoMock")

            scrollView.addSubview(subview)
        }

        scrollView.contentSize = CGSize(width: frameSize.width * CGFloat(images.count),
                                        height: frameSize.height)
    }
}

extension CarouselEventPhotosCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.scrollViewSwipeDidFinishObservable.next(Int(scrollView.contentOffset.x / scrollView.frame.width))
    }
}
