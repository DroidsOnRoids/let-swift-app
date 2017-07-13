//
//  NibRepresentable.swift
//  LetSwift
//
//  Created by Droids On Roids on 02.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

protocol NibPresentable {
    func registerNib(_ nib: UINib?, forCellReuseIdentifier identifier: String)
    func registerClass(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String)
    func registerCells(_ cellsClasses: [AnyClass])
    func registerCells(_ cellsIdentifiers: [String])
}

extension NibPresentable {
    func registerCells(_ cellsClasses: [AnyClass]) {
        cellsClasses.forEach { cellClass in
            if let _ = Bundle.main.path(forResource: String(describing: cellClass).components(separatedBy: ".").last, ofType: "nib") {
                registerNib(UINib(nibName: String(describing: cellClass), bundle: nil), forCellReuseIdentifier: String(describing: cellClass))
            } else {
                registerClass(cellClass, forCellReuseIdentifier: String(describing: cellClass))
            }
        }
    }

    func registerCells(_ cellsIdentifiers: [String]) {
        cellsIdentifiers.forEach { cellIdentifier in
            if let _ = Bundle.main.path(forResource: cellIdentifier, ofType: "nib") {
                registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
            }
        }
    }
}
