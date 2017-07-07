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
    
    private enum Constants {
        static let rotationScaleFactor: CGFloat = 0.005
    }

    @IBOutlet private weak var scrollView: AppScrollView!
    @IBOutlet private weak var onboardingImageView: OnboardingImageView!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var onboardingPageControl: UIPageControl!

    fileprivate var viewModel: OnboardingViewControllerViewModel!
    
    private let disposeBag = DisposeBag()
    
    private var scrollViewWidth: CGFloat {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewModel.pageWidthObservable.next(scrollViewWidth)
    }
    
    private func pageNumber(for offset: CGFloat) -> Int {
        let page = Int(floor(offset / scrollViewWidth + 0.5))
        
        return min(max(page, 0), onboardingPageControl.numberOfPages)
    }

    private func reactiveSetup() {
        continueButton.addTarget(viewModel, action: #selector(OnboardingViewControllerViewModel.continueButtonTapped), for: .touchUpInside)
        
        scrollView.contentOffsetObservable.subscribeNext { [weak self] offset in
            self?.viewModel.contentOffsetObservable.next(offset.x)
        }
        .add(to: disposeBag)
        
        viewModel.contentOffsetObservable.subscribeNext { [weak self] offset in
            guard let weakSelf = self else { return }
            
            weakSelf.onboardingImageView.circlesRotation = offset * Constants.rotationScaleFactor
            weakSelf.viewModel.currentPageObservable.nextDistinct(weakSelf.pageNumber(for: offset))
        }
        .add(to: disposeBag)
        
        viewModel.iconAlphaObservable.subscribeNext { [weak self] alpha in
            self?.onboardingImageView.whiteIconAlpha = alpha
        }
        .add(to: disposeBag)
        
        viewModel.pageRequestObservable.subscribeNext { [weak self] requestedPage in
            guard let weakSelf = self else { return }
            
            let xOffset = CGFloat(requestedPage) * weakSelf.scrollViewWidth
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
