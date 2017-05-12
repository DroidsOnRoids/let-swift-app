//
//  OnboardingCardView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 12.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakerCardView: DesignableView, Localizable {
    
    @IBOutlet private weak var speakerImageView: UIImageView!
    @IBOutlet private weak var speakerNameLabel: UILabel!
    @IBOutlet private weak var speakerTitleLabel: UILabel!
    @IBOutlet private weak var lectureTitleLabel: UILabel!
    @IBOutlet private weak var lectureSummaryLabel: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    var speakerImage: UIImage? {
        get {
            return speakerImageView.image
        }
        set {
            speakerImageView.image = newValue
        }
    }
    
    var speakerName: String {
        get {
            return speakerNameLabel.text ?? ""
        }
        set {
            speakerNameLabel.text = newValue
        }
    }
    
    var speakerTitle: String {
        get {
            return speakerTitleLabel.text ?? ""
        }
        set {
            speakerTitleLabel.text = newValue
        }
    }
    
    var lectureTitle: String {
        get {
            return lectureTitleLabel.text ?? ""
        }
        set {
            lectureTitleLabel.text = newValue
        }
    }
    
    var lectureSummary: String {
        get {
            return lectureSummaryLabel.text ?? ""
        }
        set {
            lectureSummaryLabel.text = newValue
        }
    }
    
    override func loadViewFromNib() {
        super.loadViewFromNib()
        
        setupLocalization()
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        layer.shadowRadius = 10.0
    }
    
    func setupLocalization() {
        readMoreButton.setTitle(localized("LECTURE_READ_MORE").uppercased(), for: [])
    }
}
