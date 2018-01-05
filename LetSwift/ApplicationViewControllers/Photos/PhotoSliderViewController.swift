//
//  PhotoSliderViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 16.06.2017.
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

final class PhotoSliderViewController: UIViewController {
    
    private enum Constants {
        static let animationDuration = 0.25
        static let panThreshold: CGFloat = 250.0
    }
    
    @IBOutlet private weak var navbarView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var statusBarTopConstraint: NSLayoutConstraint!
    
    weak var coordinatorDelegate: AppCoordinatorDelegate?
    
    private var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: 32])
    
    private var isNavbarHidden = false {
        didSet {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.navbarView.alpha = self.isNavbarHidden ? 0.0 : 1.0
            }
        }
    }
    
    private var isStatusBarHidden = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private var currentViewController: SinglePhotoViewController? {
        return pageViewController.viewControllers?.first as? SinglePhotoViewController
    }
    
    private var targetFrameClousure: (() -> CGRect)?
    private var viewModel: PhotoGalleryViewControllerViewModel!
    private var singlePhotoViewControllers: [SinglePhotoViewController]!
    
    private var animator: PhotoSliderAnimator!
    private var panRecognizer: UIPanGestureRecognizer!
    
    private let disposeBag = DisposeBag()
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    convenience init(viewModel: PhotoGalleryViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
        modalPresentationStyle = .overFullScreen
        modalPresentationCapturesStatusBarAppearance = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinatorDelegate?.rotationLocked = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let isPortrait = size.width < size.height
        panRecognizer.isEnabled = isPortrait
        isStatusBarHidden = isNavbarHidden
    }
    
    private func setup() {
        singlePhotoViewControllers = viewModel.photosObservable.value.map(SinglePhotoViewController.init)
        animator = PhotoSliderAnimator(delegate: self, animate: view)
        
        let initialViewController = singlePhotoViewControllers[viewModel.photoSelectedObservable.value]
        setupPageViewController(initialViewController: initialViewController)
        
        statusBarTopConstraint.constant = UIApplication.shared.statusBarFrame.height
        view.bringSubview(toFront: navbarView)
        
        setupGestureRecognizers()
        reactiveSetup()
    }
    
    private func setupPageViewController(initialViewController: SinglePhotoViewController) {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([initialViewController], direction: .forward, animated: false)
        addChildViewController(pageViewController)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageViewController.view)
        
        pageViewController.view.pinToFit(view: view)
        pageViewController.didMove(toParentViewController: self)
    }
    
    private func setupGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognized))
        [tapRecognizer, panRecognizer].forEach(view.addGestureRecognizer)
    }
    
    private func reactiveSetup() {
        viewModel.targetFrameObservable.subscribeNext(startsWithInitialValue: true) { [weak self] frameClousure in
            self?.targetFrameClousure = frameClousure
        }
        .add(to: disposeBag)
        
        viewModel.sliderTitleObservable.subscribeNext(startsWithInitialValue: true) { [weak self] title in
            self?.titleLabel.text = title
        }
        .add(to: disposeBag)

        viewModel.lastNaviagtionBarHiddenObservable.subscribeNext { [weak self] hidden in
            self?.isNavbarHidden = hidden
            self?.isStatusBarHidden = hidden
        }
        .add(to: disposeBag)
    }
    
    @IBAction private func backButtonTapped(_ sender: UIButton) {
        animator.animateToDismiss()
    }
    
    @objc private func tapRecognized(sender: UITapGestureRecognizer) {
        isNavbarHidden = !isNavbarHidden
        isStatusBarHidden = isNavbarHidden
    }
    
    @objc private func panRecognized(sender: UIPanGestureRecognizer) {
        guard currentViewController?.canDismissInteractively ?? false else { return }
        
        let translation = sender.translation(in: view)
        let progress = min(max(translation.y / Constants.panThreshold, -1.0), 1.0)
        
        switch sender.state {
        case .began:
            animator.interactiveAnimationHasBegan()
        case .changed:
            animator.interactiveAnimationHasChanged(progress: progress, translation: translation)
        case .ended:
            animator.interactiveAnimationHasEnded(progress: progress)
        case .cancelled:
            animator.interactiveAnimationHasCancelled()
        default: break
        }
    }
    
    private func setFirstViewController(scaleToFill: Bool) {
        currentViewController?.scaleToFill = scaleToFill
    }
}

extension PhotoSliderViewController: UIPageViewControllerDataSource {
    private func singleViewController(for viewController: SinglePhotoViewController, withOffset offset: Int) -> SinglePhotoViewController? {
        guard let index = singlePhotoViewControllers.index(of: viewController) else { return nil }
        let modifiedIndex = index + offset
        
        let indexExists = singlePhotoViewControllers.indices.contains(modifiedIndex)
        return indexExists ? singlePhotoViewControllers[modifiedIndex] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return singleViewController(for: viewController as! SinglePhotoViewController, withOffset: -1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return singleViewController(for: viewController as! SinglePhotoViewController, withOffset: 1)
    }
}

extension PhotoSliderViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = pageViewController.viewControllers?.first, let index = singlePhotoViewControllers.index(of: firstViewController as! SinglePhotoViewController) {
            viewModel.photoSelectedObservable.next(index)
        }
    }
}

extension PhotoSliderViewController: PhotoSliderAnimatorDelegate {
    func prepareForInteractiveAnimation() {
        viewModel.targetVisibleObservable.next(currentViewController?.shouldHideTargetThumbnail ?? false)
        viewModel.restoreNaviationBarVisibilityObservable.next(isNavbarHidden)
        isNavbarHidden = true
        isStatusBarHidden = false
    }
    
    func prepareForDismissing() {
        coordinatorDelegate?.rotationLocked = true
        viewModel.targetVisibleObservable.next(currentViewController?.shouldHideTargetThumbnail ?? false)
        navbarView.isHidden = true
    }
    
    func progressDismissing() {
        view.frame = targetFrameClousure?() ?? .zero
        setFirstViewController(scaleToFill: true)
    }
    
    func finishDismissing() {
        viewModel.targetVisibleObservable.next(false)
        dismiss(animated: false)
    }
    
    func prepareForRestore() {
        viewModel.targetVisibleObservable.next(false)
        viewModel.restoreNaviationBarVisibilityObservable.complete()
    }
}
