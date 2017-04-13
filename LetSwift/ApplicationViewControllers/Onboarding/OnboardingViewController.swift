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
    fileprivate var currentPage = 0
    
    convenience init(viewModel: OnboardingViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        setupLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layoutIfNeeded()
        setupScrollView()
    }

    func setupScrollView() {
        let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
        let frameSize = scrollView.frame.size

        (0..<colors.count).forEach { index in
            let frame = CGRect(origin: CGPoint(x: frameSize.width * CGFloat(index), y: 0),
                               size: frameSize)

            let subView = UIView(frame: frame)
            subView.backgroundColor = colors[index]
            scrollView.addSubview(subView)
        }

        scrollView.contentSize = CGSize(width: frameSize.width * CGFloat(colors.count),
                                        height: frameSize.height)
    }

    func changePage(page: Int) {
        let xPosition = CGFloat(page) * scrollView.frame.size.width

        if xPosition < scrollView.contentSize.width {
            scrollView.setContentOffset(CGPoint(x: xPosition, y: 0), animated: true)
            currentPage = page
        }
    }

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        changePage(page: currentPage + 1)
    }
}

extension OnboardingViewController: Localizable {
    
    func setupLocalization() {
        continueButton.setTitle(localized("ONBOARDING_CONTINUE").uppercased(), for: .normal)
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //viewModel.currentPage.next(Int(scrollView.contentOffset.x / scrollView.frame.size.width))
    }
}
