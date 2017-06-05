//
//  NibRepresentable.swift
//  LetSwift
//
//  Created by Droids On Roids on 02.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
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
