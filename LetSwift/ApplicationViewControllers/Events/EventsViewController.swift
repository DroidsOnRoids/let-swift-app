//
//  EventsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocalization()
        setupViews()
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "UserIcon"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
}

extension EventsViewController: Localizable {
    func setupLocalization() {
        title = localized("EVENTS_TITLE").uppercased()
    }
}
