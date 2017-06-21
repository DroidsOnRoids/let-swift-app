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
    
    @IBOutlet private weak var navbarView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    weak var coordinatorDelegate: AppCoordinatorDelegate?
    
    private var pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey : 32])
    private var isStatusBarHidden = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    fileprivate var viewModel: PhotoGalleryViewControllerViewModel!
    fileprivate var singlePhotoViewControllers: [SinglePhotoViewController]!
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinatorDelegate?.rotationLocked = true
    }
    
    private func setup() {
        singlePhotoViewControllers = viewModel.photosObservable.value.map(SinglePhotoViewController.init)
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
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognized))
        [tapRecognizer, panRecognizer].forEach(view.addGestureRecognizer)
    }
    
    private func reactiveSetup() {
        viewModel.sliderTitleObservable.subscribeNext(startsWithInitialValue: true) { [weak self] title in
            self?.titleLabel.text = title
        }
        .add(to: disposeBag)
    }
    
    @IBAction private func backButtonTapped(_ sender: UIButton) {
        navbarView.isHidden = true
        animateToDismiss()
    }
    
    @objc private func tapRecognized(sender: UITapGestureRecognizer) {
        if isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: Constants.animationDuration) {
                self.navbarView.transform = .identity
            }
        } else {
            isStatusBarHidden = true
            UIView.animate(withDuration: Constants.animationDuration) {
                self.navbarView.transform = CGAffineTransform(translationX: 0.0, y: -self.navbarView.bounds.height)
            }
        }
    }
    
    var initialFrame: CGRect!
    
    var targetFrame: CGRect {
        return viewModel.targetFrameObservable.value
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialFrame = view.frame
    }
    

    
    @objc private func panRecognized(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = min(max(translation.y / Constants.panThreshold, -1.0), 1.0)
        
        switch sender.state {
        case .began:
            interactiveAnimationHasBegan(progress: progress, translation: translation)
        case .changed:
            interactiveAnimationHasChanged(progress: progress, translation: translation)
        case .ended:
            interactiveAnimationHasEnded(progress: progress, translation: translation)
        default: break
        }
    }
    
    private func setFirstViewController(scaleToFill: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.first as? SinglePhotoViewController else { return }
        currentViewController.scaleToFill = scaleToFill
    }
    
    private func interactiveAnimationHasBegan(progress: CGFloat, translation: CGPoint) {
        viewModel.targetVisibleObservable.value?(true)
    }
    
    private func interactiveAnimationHasChanged(progress: CGFloat, translation: CGPoint) {
        let reversedProgress = min(1.0 - progress, 1.0)
        print(reversedProgress)
        let alphaInterpolation = min(reversedProgress * 2.0 - 1.0, 1.0)
        let scaleInterpolation = reversedProgress / 4.0 + 0.75
        
        var newFrame = initialFrame.scale(by: scaleInterpolation)
        newFrame.origin.y *= 0.25
        newFrame = newFrame.offsetBy(dx: translation.x, dy: translation.y)
        
        navbarView.isHidden = true
        
        view.backgroundColor = UIColor.black.withAlphaComponent(alphaInterpolation)
        view.frame = newFrame
    }
    
    private func interactiveAnimationHasEnded(progress: CGFloat, translation: CGPoint) {
        if progress > 0.5 {
            print("animuj do zamkniecia")
            animateToDismiss()
        } else {
            print("animuj powrot")
            animateToRestore()
        }
    }
    
    private func animateToDismiss() {
        //coordinatorDelegate?.rotationLocked = true
        viewModel.targetVisibleObservable.value?(true)
        
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = .clear
            self.view.frame = self.targetFrame
            self.view.layoutIfNeeded()
            self.setFirstViewController(scaleToFill: true)
        }) { _ in
            self.viewModel.targetVisibleObservable.value?(false)
            self.dismiss(animated: false)
        }
    }
    
    private func animateToRestore() {
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = .black
            self.view.frame = self.initialFrame
            self.view.layoutIfNeeded()
        }) { _ in
            self.navbarView.isHidden = false
        }
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
