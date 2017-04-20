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
    
    private var randomString: String {
        return (0..<finalResult.length).reduce("") { result, _ in
            return result + "\(Character(UnicodeScalar(UInt8(arc4random_uniform(95) + 32))))"
        }
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
