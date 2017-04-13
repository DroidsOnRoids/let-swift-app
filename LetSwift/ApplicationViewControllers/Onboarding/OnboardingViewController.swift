//
//  OnboardingViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 12.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate: class {
    func dismissOnboardingViewController()
}

final class OnboardingViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var continueButton: UIButton!

    fileprivate var viewModel: OnboardingViewControllerViewModel!
    
    convenience init(viewModel: OnboardingViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        setupViewModel()
        setupLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layoutIfNeeded()
        setupScrollView()
    }

    private func setupScrollView() {
        let colors: [UIColor] = [.red, .blue, .green, .yellow]
        let frameSize = scrollView.frame.size

        colors.enumerated().forEach { index, color in
            let frame = CGRect(origin: CGPoint(x: frameSize.width * CGFloat(index), y: 0.0),
                               size: frameSize)

            let subview = UIView(frame: frame)
            subview.backgroundColor = colors[index]

            scrollView.addSubview(subview)
        }

        scrollView.contentSize = CGSize(width: frameSize.width * CGFloat(colors.count),
                                        height: frameSize.height)
    }

    private func setupViewModel() {
        continueButton.addTarget(viewModel, action: #selector(OnboardingViewControllerViewModel.continueButtonTapped), for: .touchUpInside)

        viewModel.currentPage.subscribe(onNext: { [unowned self] page in
            let xPosition = CGFloat(page) * self.scrollView.frame.width

            if xPosition < self.scrollView.contentSize.width {
                self.scrollView.setContentOffset(CGPoint(x: xPosition, y: 0.0), animated: true)
            }
        })
    }
}

extension OnboardingViewController: Localizable {
    func setupLocalization() {
        continueButton.setTitle(localized("ONBOARDING_CONTINUE").uppercased(), for: [])
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.swipeDidFinish(with: Int(scrollView.contentOffset.x / scrollView.frame.size.width))
    }
}
