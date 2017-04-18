//
//  RandomLabelAnimator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 18.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

struct RandomLabelAnimator {

    let label: UILabel
    let finalResult: NSAttributedString

    private func randomString(length: Int) -> String {
        var result = ""

        for _ in 0..<length {
            // 32 - 126 are allowed ASCII codes
            let randomAsciiCode = UInt8(arc4random_uniform(95) + 32)
            let randomCharacter = Character(UnicodeScalar(randomAsciiCode))

            result.append(randomCharacter)
        }

        return result
    }

    func animate(withSteps steps: Int = 15, interval: TimeInterval = 0.1) {
        DispatchQueue.global(qos: .userInteractive).async {
            for _ in 0..<steps {
                DispatchQueue.main.async {
                    self.label.text = self.randomString(length: self.finalResult.length)
                }

                Thread.sleep(forTimeInterval: interval)
            }

            DispatchQueue.main.async {
                self.label.attributedText = self.finalResult
            }
        }
    }
}
