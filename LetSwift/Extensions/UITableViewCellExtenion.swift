//
//  UITableViewCellExtenion.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 13.06.2017.
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

extension UITableViewCell {
    func removeSeparators() {
        let largeIndent: CGFloat = .infinity
        separatorInset = UIEdgeInsets(top: 0.0, left: largeIndent, bottom: 0.0, right: 0.0)
        indentationWidth = -largeIndent
        indentationLevel = 1
    }
}
