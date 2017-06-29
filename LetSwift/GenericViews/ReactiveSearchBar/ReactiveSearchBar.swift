//
//  ReactiveSearchBar.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 28.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class ReactiveSearchBar: UISearchBar {

    var searchBarSearchButtonClickedObservable = Observable<String>("")
    var searchBarCancelButtonClicked = Observable<Void>()
    var searchBarWillStartEditingObservable = Observable<Void>()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {
        delegate = self

        layer.borderWidth = 1.0
        layer.borderColor = UIColor.paleGrey.cgColor
        layer.zPosition = 1
        placeholder = localized("SPEAKERS_SEARCH_PLACEHOLDER")
        tintColor = .bluishGrey
    }
}

extension ReactiveSearchBar: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBarWillStartEditingObservable.next()
        setShowsCancelButton(true, animated: true)
        
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        searchBarSearchButtonClickedObservable.next(searchBar.text ?? "")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        setShowsCancelButton(false, animated: true)
        resignFirstResponder()
        searchBarCancelButtonClicked.next()
    }
}
