//
//  SpeakerCardCollectionViewCell
//  LetSwift
//
//  Created by Marcin Chojnacki on 29.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class SpeakerCardCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = String(describing: SpeakerCardCollectionViewCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        
    }
}
