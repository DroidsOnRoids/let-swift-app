//
//  StaticImageTableViewCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class StaticImageTableViewCell: UITableViewCell {
    @IBOutlet weak var someName: UILabel!
    
    @IBOutlet weak var reflectiveImageView: ReflectionShadowView!
}