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
    
    private var pageViewController: UIPageViewController!
    private var isStatusBarHidden = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    fileprivate var viewModel: PhotoGalleryViewControllerViewModel!
    
    private let disposeBag = DisposeBag()
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return .overFullScreen
        }
        set {
        }
    }
    
    override var modalPresentationCapturesStatusBarAppearance: Bool {
        get {
            return true
        }
        set {
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    convenience init(viewModel: PhotoGalleryViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate var singlePhotoViewControllers: [SinglePhotoViewController]!
    
    private func setup() {
        singlePhotoViewControllers = viewModel.photosObservable.value.map {
            SinglePhotoViewController(photo: $0)
        }
        
        let initialViewController = singlePhotoViewControllers[viewModel.photoSelectedObservable.value]
        setupPageViewController(initialViewController: initialViewController)
        view.bringSubview(toFront: navbarView)
        setupGestureRecognizers()
        reactiveSetup()
    }
    
    private func setupPageViewController(initialViewController: SinglePhotoViewController) {
        let optionsDict = [UIPageViewControllerOptionInterPageSpacingKey : 32]
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: optionsDict)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([initialViewController], direction: .forward, animated: false)
        addChildViewController(pageViewController)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageViewController.view)
        
        pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        pageViewController.didMove(toParentViewController: self)
    }
    
    private func setupGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        view.addGestureRecognizer(tapRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognized))
        view.addGestureRecognizer(panRecognizer)
    }
    
    private func reactiveSetup() {
        viewModel.sliderTitleObservable.subscribeNext(startsWithInitialValue: true) { [weak self] title in
            self?.titleLabel.text = title
        }
        .add(to: disposeBag)
    }
    
    @IBAction private func backButtonTapped(_ sender: UIButton) {
        self.navbarView.isHidden = true
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.frame = self.viewModel.targetFrameObservable.value
            self.view.layoutIfNeeded()
            self.view.alpha = 0.0
        }, completion: { _ in
            self.dismiss(animated: false)
        })
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
        let index = singlePhotoViewControllers.index(of: viewController)
        guard let newIndex = index else { return nil }
        let modifiedIndex = newIndex + offset
        
        let exists = singlePhotoViewControllers.indices.contains(modifiedIndex)
        return exists ? singlePhotoViewControllers[modifiedIndex] : nil
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
        guard let firstVC = pageViewController.viewControllers?.first, let index = singlePhotoViewControllers.index(of: firstVC as! SinglePhotoViewController) else { return }
        
        viewModel.photoSelectedObservable.next(index)
    }
}
