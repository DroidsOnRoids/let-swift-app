//
//  OnboardingViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 12.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerCoordinatorDelegate: class {
    func onboardingHasCompleted()
}

final class OnboardingViewController: UIViewController {

    @IBOutlet private weak var scrollView: AppScrollView!
    @IBOutlet private weak var onboardingImageView: OnboardingImageView!
    @IBOutlet fileprivate weak var continueButton: UIButton!
    @IBOutlet private weak var onboardingPageControl: UIPageControl!

    fileprivate var viewModel: OnboardingViewControllerViewModel!
    
    private let disposeBag = DisposeBag()
    
    convenience init(viewModel: OnboardingViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        reactiveSetup()
    }
    
    private func alphaValue(forSingleWidth singleWidth: CGFloat, offset: CGFloat) -> CGFloat {
        let halfWidth = singleWidth / 2.0
        var result = abs(offset.truncatingRemainder(dividingBy: singleWidth))
        
        if result > halfWidth {
            result -= 2.0 * (result - halfWidth)
        }
        
        result /= halfWidth
        result = 1.0 - result
        
        return result
    }
    
    private func pageNumber(forSingleWidth singleWidth: CGFloat, offset: CGFloat) -> Int {
        return Int(floor(offset / singleWidth + 0.5))
    }

    private func reactiveSetup() {
        continueButton.addTarget(viewModel, action: #selector(OnboardingViewControllerViewModel.continueButtonTapped), for: .touchUpInside)
        
        scrollView.contentOffsetObservable.subscribeNext { [weak self] offset in
            guard let weakSelf = self else { return }
            let singleWidth = weakSelf.scrollView.frame.width
            
            weakSelf.onboardingImageView.circlesRotation = offset.x * 0.005
            weakSelf.onboardingImageView.whiteIconAlpha = weakSelf.alphaValue(forSingleWidth: singleWidth, offset: offset.x)
            weakSelf.viewModel.swipeDidFinish(with: weakSelf.pageNumber(forSingleWidth: singleWidth, offset: offset.x))
        }
        .add(to: disposeBag)

        viewModel.currentPageObservable.subscribeNext { [weak self] page in
            guard let weakSelf = self else { return }
            
            //weakSelf.onboardingImageView.whiteIconImage =
            switch page {
            case 0: weakSelf.onboardingImageView.whiteIconImage = #imageLiteral(resourceName: "OnboardingPrice")
            case 1: weakSelf.onboardingImageView.whiteIconImage = #imageLiteral(resourceName: "OnboardingMeetups")
            case 2: weakSelf.onboardingImageView.whiteIconImage = #imageLiteral(resourceName: "OnboardingSpeakers")
            default: break
            }
            
            
            weakSelf.onboardingPageControl.currentPage = page
            /*let xOffset = weakSelf.scrollView.contentOffset.x
            let singleWidth = weakSelf.scrollView.frame.width
            
            if xOffset >= 0.0 && xOffset <= weakSelf.scrollView.contentSize.width - singleWidth {
                let xPosition = CGFloat(page) * singleWidth

                weakSelf.scrollView.setContentOffset(CGPoint(x: xPosition, y: 0.0), animated: true)
                weakSelf.onboardingPageControl.currentPage = page
            }*/
        }
        .add(to: disposeBag)

        viewModel.continueButtonTitleObservable.subscribeNext(startsWithInitialValue: true) { [weak self] title in
            self?.continueButton.setTitle(title, for: [])
        }
        .add(to: disposeBag)
        
        viewModel.onboardingCardsObservable.subscribeNext(startsWithInitialValue: true) { [weak self] cards in
            DispatchQueue.main.async {
                self?.setupScrollView(with: cards)
                self?.onboardingPageControl.numberOfPages = cards.count
            }
        }
        .add(to: disposeBag)
    }
    
    private func setupScrollView(with cards: [OnboardingCardModel]) {
        let frameSize = scrollView.frame.size

        cards.enumerated().forEach { index, card in
            let frame = CGRect(origin: CGPoint(x: frameSize.width * CGFloat(index), y: 0.0),
                               size: frameSize)
            
            let subview = OnboardingCardView(frame: frame)
            subview.setData(with: card)
            
            scrollView.addSubview(subview)
        }

        scrollView.contentSize = CGSize(width: frameSize.width * CGFloat(cards.count),
                                        height: frameSize.height)
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    /*func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.swipeDidFinish(with: Int(scrollView.contentOffset.x / scrollView.frame.width))
    }*/
}
