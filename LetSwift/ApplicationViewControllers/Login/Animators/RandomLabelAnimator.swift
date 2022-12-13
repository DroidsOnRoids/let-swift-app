//
//  RandomLabelAnimator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 18.04.2017.
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

final class RandomLabelAnimator {
    
    let label: UILabel
    let finalResult: NSAttributedString
    
    private var randomString: String {
        return (0..<finalResult.length).reduce("") { result, _ in
            result + "\(Character(UnicodeScalar(UInt8.random(in: 32..<128))))"
        }
    }
    
    init(label: UILabel, finalResult: NSAttributedString) {
        self.label = label
        self.finalResult = finalResult
    }
    
    func animate(withSteps steps: Int = 15, interval: TimeInterval = 0.1) {
        DispatchQueue.global(qos: .userInteractive).async {
            (0..<steps).forEach { _ in
                DispatchQueue.main.async {
                    self.label.text = self.randomString
                }

                Thread.sleep(forTimeInterval: interval)
            }

            DispatchQueue.main.async {
                self.label.attributedText = self.finalResult
            }
        }
    }
}
