//
//  OnboardingViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 12.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate, Localizable {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var continueButton: UIButton!

    private var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupLocalization()
    }

    func setupLocalization() {
        continueButton.setTitle(localized("ONBOARDING_CONTINUE").uppercased(), for: .normal)
    }

    func setupScrollView() {
        let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
        let frameSize = scrollView.frame.size

        for index in 0..<colors.count {
            let frame = CGRect(origin: CGPoint(x: frameSize.width * CGFloat(index), y: 0),
                               size: frameSize)

            let subView = UIView(frame: frame)
            subView.backgroundColor = colors[index]
            scrollView.addSubview(subView)
        }

        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: frameSize.width * CGFloat(colors.count),
                                        height: frameSize.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
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
