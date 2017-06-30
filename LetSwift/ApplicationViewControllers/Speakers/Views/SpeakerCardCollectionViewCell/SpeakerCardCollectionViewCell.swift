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
    
    var lectureDetailsObservable = Observable<Int?>(nil)
    
    private let lectureCard = SpeakerCardView()
    private var talkId: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func load(with speaker: Speaker, talk: Talk) {
        lectureCard.speakerImageURL = speaker.avatar?.thumb
        lectureCard.speakerName = speaker.name
        lectureCard.speakerTitle = speaker.job
        lectureCard.lectureTitle = talk.title
        lectureCard.lectureSummary = talk.description
        lectureCard.isSpeakerCellTappable = false
        lectureCard.addReadMoreTapTarget(target: self, action: #selector(readMoreTapped))
        talkId = talk.id
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lectureDetailsObservable = Observable<Int?>(nil)
    }
    
    private func setup() {
        lectureCard.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lectureCard)
        lectureCard.pinToFit(view: self)
    }
    
    @objc private func readMoreTapped() {
        lectureDetailsObservable.next(talkId)
    }
}
