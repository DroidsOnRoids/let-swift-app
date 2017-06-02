//
//  TopicPickerViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 02.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class TopicPickerViewController: UIViewController {
    
    private enum Constants {
        static let animationDuration = 0.25
        static let backgroundAlpha: CGFloat = 0.25
    }
    
    @IBOutlet private weak var separatorConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var cancelView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var doneButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    private var items: [String]?
    private var callback: ((Int) -> ())?
    private var outOfScreenTransform: CGAffineTransform!
    
    private let disposeBag = DisposeBag()
    
    static func present(on viewController: UIViewController, items: [String], callback: ((Int) -> ())? = nil) {
        viewController.present(TopicPickerViewController(items: items, callback: callback), animated: false)
    }
    
    private convenience init(items: [String], callback: ((Int) -> ())?) {
        self.init(nibName: nil, bundle: nil)
        self.items = items
        self.callback = callback
        
        modalPresentationStyle = .overFullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        outOfScreenTransform = CGAffineTransform(translationX: 0.0, y: containerView.bounds.height)
        containerView.transform = outOfScreenTransform
        
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(Constants.backgroundAlpha)
            self.containerView.transform = .identity
        })
    }
    
    private func setup() {
        setupViews()
        setupDismissing()
        setupTableView()
        setupLocalization()
    }
    
    private func setupViews() {
        separatorConstraint.constant = 1.0 / UIScreen.main.scale
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        containerView.layer.shadowRadius = 15.0
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 1.0))
    }
    
    private func setupDismissing() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(closePicker))
        cancelView.addGestureRecognizer(recognizer)
        
        doneButton.addTarget(self, action: #selector(closePicker), for: .touchUpInside)
    }
    
    private func setupTableView() {
        guard let items = items else { return }
        
        items.bindable.bind(to: tableView.items() ({ tableView, _, element in
            let cellIdentifier = "SimpleCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            
            cell.textLabel?.attributedText = element.attributed(withFont: .systemFont(ofSize: 14.0, weight: UIFontWeightRegular)).with(color: .coolGrey)
            
            return cell
        }))
        
        tableView.itemDidSelectObservable.subscribeNext { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            
            self?.callback?(indexPath.row)
            self?.closePicker()
        }
        .add(to: disposeBag)
    }
    
    @objc private func closePicker() {
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = .clear
            self.containerView.transform = self.outOfScreenTransform
        }) { completed in
            self.dismiss(animated: false)
        }
    }
}

extension TopicPickerViewController: Localizable {
    func setupLocalization() {
        titleLabel.text = localized("CONTACT_PICKER_TITLE")
        doneButton.setTitle(localized("CONTACT_CANCEL"), for: [])
    }
}
