//
//  PhotoSliderViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 16.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class PhotoSliderViewController: UIViewController {
    
    private enum Constants {
        static let animationDuration = 0.25
        static let panThreshold: CGFloat = 250.0
    }
    
    @IBOutlet fileprivate weak var navbarView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    weak var coordinatorDelegate: AppCoordinatorDelegate?
    
    fileprivate var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey : 32])
    
    fileprivate var isNavbarHidden = false {
        didSet {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.navbarView.alpha = self.isNavbarHidden ? 0.0 : 1.0
            }
        }
    }
    
    fileprivate var isStatusBarHidden = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    fileprivate var targetFrame: CGRect!
    fileprivate var viewModel: PhotoGalleryViewControllerViewModel!
    fileprivate var singlePhotoViewControllers: [SinglePhotoViewController]!
    
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
        panRecognizer.isEnabled = size.width < size.height
    }
    
    private func setup() {
        singlePhotoViewControllers = viewModel.photosObservable.value.map(SinglePhotoViewController.init)
        animator = PhotoSliderAnimator(delegate: self, animate: view)
        
        let initialViewController = singlePhotoViewControllers[viewModel.photoSelectedObservable.value]
        setupPageViewController(initialViewController: initialViewController)
        
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
        viewModel.targetFrameObservable.subscribeNext(startsWithInitialValue: true) { [weak self] frame in
            self?.targetFrame = frame
        }
        .add(to: disposeBag)
        
        viewModel.sliderTitleObservable.subscribeNext(startsWithInitialValue: true) { [weak self] title in
            self?.titleLabel.text = title
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
    
    fileprivate func setFirstViewController(scaleToFill: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.first as? SinglePhotoViewController else { return }
        currentViewController.scaleToFill = scaleToFill
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
        viewModel.targetVisibleObservable.next(true)
        isNavbarHidden = true
        isStatusBarHidden = false
    }
    
    func prepareForDismissing() {
        coordinatorDelegate?.rotationLocked = true
        viewModel.targetVisibleObservable.next(true)
        navbarView.isHidden = true
    }
    
    func progressDismissing() {
        view.frame = targetFrame
        setFirstViewController(scaleToFill: true)
    }
    
    func finishDismissing() {
        viewModel.targetVisibleObservable.next(false)
        dismiss(animated: false)
    }
    
    func prepareForRestore() {
        isNavbarHidden = false
    }
}
