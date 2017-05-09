//
//  PopoverViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 08.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class PopoverViewController: UIViewController {
    
    private enum Constants {
        static let animationDuration = 0.2
    }
    
    weak var target: AnyObject?
    var action: Selector?
    
    private let container = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    private let maskView = PopoverView()
    private let button = UIButton()
    
    var arrowPosition: Double {
        get {
            return maskView.arrowPosition
        }
        
        set {
            maskView.arrowPosition = newValue
            container.layer.anchorPoint = CGPoint(x: newValue, y: 0.0)
            container.mask = maskView
        }
    }
    
    var popoverAnchor: CGPoint {
        get {
            return container.center
        }
        
        set {
            container.center = newValue
        }
    }
    
    var popoverTitle = "" {
        didSet {
            let attributedTitle = popoverTitle.attributed(withFont: .systemFont(ofSize: 15.0, weight: UIFontWeightMedium)).with(spacing: 0.5)
            button.setAttributedTitle(attributedTitle.with(color: .black), for: [])
            button.setAttributedTitle(attributedTitle.with(color: .darkGray), for: .highlighted)
        }
    }
    
    var popoverSize = CGSize(width: 112.0, height: 44.0)
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(container)
    }
    
    private func setup() {
        modalPresentationStyle = .overFullScreen
        container.frame = CGRect(x: 0.0, y: 0.0, width: popoverSize.width, height: popoverSize.height)
        
        maskView.frame = container.bounds
        maskView.backgroundColor = .black
        arrowPosition = maskView.arrowPosition
        
        button.frame = maskView.childRect
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        container.addSubview(button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        container.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: .curveEaseOut, animations: {
            self.container.transform = .identity
        })
    }
    
    @objc private func buttonTapped() {
        closePopover()
        _ = target?.perform(action)
    }
    
    func presentPopover(on viewController: UIViewController) {
        viewController.present(self, animated: false)
    }
    
    private func closePopover() {
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: { completed in
            self.dismiss(animated: false)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closePopover()
    }
}
