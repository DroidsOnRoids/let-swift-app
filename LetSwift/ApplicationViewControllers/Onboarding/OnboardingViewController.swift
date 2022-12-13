//
//  OnboardingViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 12.04.2017.
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

protocol OnboardingViewControllerCoordinatorDelegate: AnyObject {
    func onboardingHasCompleted()
}

final class OnboardingViewController: UIViewController {
    
    private enum Constants {
        static let rotationScaleFactor: CGFloat = 0.005
    }

    @IBOutlet private weak var eventNameLabel: UILabel!
    @IBOutlet private weak var scrollView: AppScrollView!
    @IBOutlet private weak var onboardingImageView: OnboardingImageView!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var onboardingPageControl: UIPageControl!
    @IBOutlet private weak var cardTemplateView: UIView!
    
    private var viewModel: OnboardingViewControllerViewModel!
    
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
        
        setupBranding()
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

    private func setupBranding() {
        eventNameLabel.text = EventBranding.current.name
        
        onboardingPageControl.currentPageIndicatorTintColor = .brandingColor
        setupContinueButton(with: .brandingColor)
    }
    
    private func setupContinueButton(with color: UIColor) {
        continueButton.setTitleColor(color, for: .normal)
        continueButton.setTitleColor(color.withAlphaComponent(0.3), for: .highlighted)
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
            DispatchQueue.main.async {
                self?.setupScrollView(with: cards)
                self?.onboardingPageControl.numberOfPages = cards.count
            }
        }
        .add(to: disposeBag)
    }
    
    private func setupScrollView(with cards: [OnboardingCardModel]) {
        let scrollViewSize = scrollView.frame.size
        let templateFrame = scrollView.convert(cardTemplateView.frame, from: view)

        scrollView.subviews.forEach { $0.removeFromSuperview() }
        cardTemplateView.removeFromSuperview()

        cards.enumerated().forEach { index, card in
            let frame = templateFrame.offsetBy(dx: scrollViewSize.width * CGFloat(index), dy: 0.0)
            
            let subview = OnboardingCardView(frame: frame)
            subview.setupLabels(with: card)
            
            scrollView.addSubview(subview)
        }

        scrollView.contentSize = CGSize(width: scrollViewSize.width * CGFloat(cards.count), height: scrollViewSize.height)
    }
}
