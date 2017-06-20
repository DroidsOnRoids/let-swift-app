//
//  PhotoSliderViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 16.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class PhotoSliderViewController: UIViewController {
    
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
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.frame = self.viewModel.targetFrameObservable.value
            self.view.layoutIfNeeded()
            self.view.alpha = 0.0
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    @objc private func tapRecognized(sender: UITapGestureRecognizer) {
        if isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.25) {
                self.navbarView.transform = .identity
            }
        } else {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.25) {
                self.navbarView.transform = CGAffineTransform(translationX: 0.0, y: -self.navbarView.bounds.height)
            }
        }
    }
    
    @objc private func panRecognized(sender: UIPanGestureRecognizer) {
        // TODO: implement
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
