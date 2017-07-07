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
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var onboardingPageControl: UIPageControl!

    fileprivate var viewModel: OnboardingViewControllerViewModel!
    
    private let disposeBag = DisposeBag()
    
    private var singleWidth: CGFloat {
        return scrollView.frame.width
    }
    
    convenience init(viewModel: OnboardingViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reactiveSetup()
    }
    
    private func alphaValue(for offset: CGFloat) -> CGFloat {
        let halfWidth = singleWidth / 2.0
        var result = abs(offset.truncatingRemainder(dividingBy: singleWidth))
        
        if result > halfWidth {
            result -= 2.0 * (result - halfWidth)
        }
        
        result /= halfWidth
        result = 1.0 - result
        
        return result
    }
    
    private func pageNumber(for offset: CGFloat) -> Int {
        let page = Int(floor(offset / singleWidth + 0.5))
        
        return min(max(page, 0), onboardingPageControl.numberOfPages)
    }

    private func reactiveSetup() {
        continueButton.addTarget(viewModel, action: #selector(OnboardingViewControllerViewModel.continueButtonTapped), for: .touchUpInside)
        
        scrollView.contentOffsetObservable.subscribeNext { [weak self] offset in
            guard let weakSelf = self else { return }
            
            weakSelf.onboardingImageView.circlesRotation = offset.x * 0.005
            weakSelf.onboardingImageView.whiteIconAlpha = weakSelf.alphaValue(for: offset.x)
            
            let pageNumber = weakSelf.pageNumber(for: offset.x)
            if pageNumber != weakSelf.viewModel.currentPageObservable.value {
                weakSelf.viewModel.currentPageObservable.next(pageNumber)
            }
        }
        .add(to: disposeBag)
        
        viewModel.pageRequestObservable.subscribeNext { [weak self] requestedPage in
            guard let weakSelf = self else { return }
            
            let xOffset = CGFloat(requestedPage) * weakSelf.singleWidth
            weakSelf.scrollView.setContentOffset(CGPoint(x: xOffset, y: 0.0), animated: true)
        }
        .add(to: disposeBag)

        viewModel.currentPageObservable.subscribeNext(startsWithInitialValue: true) { [weak self] page in
            self?.onboardingPageControl.currentPage = page
        }
        .add(to: disposeBag)
        
        viewModel.currentIconObservable.subscribeNext(startsWithInitialValue: true) { [weak self] iconName in
            guard let iconName = iconName else { return }
            self?.onboardingImageView.whiteIconImage = UIImage(named: iconName)
        }
        .add(to: disposeBag)

        viewModel.continueButtonTitleObservable.subscribeNext(startsWithInitialValue: true) { [weak self] title in
            self?.continueButton.setTitle(title, for: [])
        }
        .add(to: disposeBag)
        
        viewModel.onboardingCardsObservable.subscribeNext(startsWithInitialValue: true) { [weak self] cards in
            self?.setupScrollView(with: cards)
            self?.onboardingPageControl.numberOfPages = cards.count
        }
        .add(to: disposeBag)
    }
    
    private func setupScrollView(with cards: [OnboardingCardModel]) {
        let frameSize = scrollView.frame.size
        
        scrollView.subviews.forEach { $0.removeFromSuperview() }

        cards.enumerated().forEach { index, card in
            let frame = CGRect(origin: CGPoint(x: frameSize.width * CGFloat(index), y: 0.0), size: frameSize)
            
            let subview = OnboardingCardView(frame: frame)
            subview.setData(with: card)
            
            scrollView.addSubview(subview)
        }

        scrollView.contentSize = CGSize(width: frameSize.width * CGFloat(cards.count), height: frameSize.height)
    }
}
