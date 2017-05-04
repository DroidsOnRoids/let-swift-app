//
//  EventsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventsViewController: AppViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: EventsViewControllerViewModel!

    convenience init(viewModel: EventsViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "StaticImageTableViewCell", bundle: nil), forCellReuseIdentifier: "StaticImageTableViewCell")

        let bindableArray = ["Cos", "Cos", "nic", "Ale działa"].bindable
        bindableArray.bind(to: tableView.item(with: "StaticImageTableViewCell", cellType: StaticImageTableViewCell.self) ({ index, item, cell in
//            if index % 2 == 0 {
//                cell.reflectiveImageView.image = #imageLiteral(resourceName: "EventsActive")
//            } else {
//                cell.reflectiveImageView.image = #imageLiteral(resourceName: "OnboardingMeetups")
//            }
            cell.someName.text = item
        }))

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            bindableArray.append("Hehhe")
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            bindableArray.append("No")
        }
    }

    override func viewControllerTitleKey() -> String? {
        return "EVENTS_TITLE"
    }

    override func shouldShowUserIcon() -> Bool {
        return true
    }

    override func shouldHideShadow() -> Bool {
        return true
    }

    private func setup() {
    }
}
