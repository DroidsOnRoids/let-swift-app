//
//  RandomLabelAnimator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 18.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class RandomLabelAnimator {
    
    let label: UILabel
    let finalResult: NSAttributedString
    
    private var currentStep = 0
    private var steps = 0
    private var interval = 0.0
    
    private var randomString: String {
        return (0..<finalResult.length).reduce("") { result, _ in
            result + "\(Character(UnicodeScalar(UInt8(arc4random_uniform(95) + 32))))"
        }
    }
    
    init(label: UILabel, finalResult: NSAttributedString) {
        self.label = label
        self.finalResult = finalResult
    }
    
    func animate(withSteps steps: Int = 15, interval: TimeInterval = 0.1) {
        self.steps = steps
        self.interval = interval
        
        animate()
    }
    
    @objc fileprivate func animate() {
        if currentStep < steps {
            currentStep += 1
            
            exposeResultToMain(block: { [weak self] _ in self?.label.text = self?.randomString })
            
            Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(animate), userInfo: nil, repeats: false)
        } else {
            exposeResultToMain(block: { [weak self] _ in self?.label.attributedText = self?.finalResult })
        }
    }
    
    private func exposeResultToMain(block: @escaping ()->()) {
        DispatchQueue.main.async {
            block()
        }
    }
}
