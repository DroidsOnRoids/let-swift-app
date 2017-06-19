//
//  SpeakersViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 14.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class SpeakersViewControllerViewModel {

    weak var delegate: SpeakersViewControllerDelegate?

    init(delegate: SpeakersViewControllerDelegate?) {
        self.delegate = delegate
    }
}
