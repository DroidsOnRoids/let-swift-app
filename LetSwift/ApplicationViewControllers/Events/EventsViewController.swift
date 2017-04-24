//
//  EventsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventsViewController: AppViewController {
    
    override func viewControllerTitleKey() -> String? {
        return "EVENTS_TITLE"
    }
    
    override func shouldShowUserIcon() -> Bool {
        return true
    }
    
    override func shouldHideShadow() -> Bool {
        return true
    }
}
