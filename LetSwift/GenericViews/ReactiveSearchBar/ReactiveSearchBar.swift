//
//  ReactiveSearchBar.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 28.06.2017.
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

final class ReactiveSearchBar: UISearchBar {

    var searchBarSearchButtonClickedObservable = Observable<String>("")
    var searchBarCancelButtonClicked = Observable<Void>()
    var searchBarWillStartEditingObservable = Observable<Void>()
    var searchBarTextDidChangeObservable = Observable<String>("")

    private lazy var textDidChangeDebouncer = Debouncer(delay: 0.3, callback: self.textDidChange)

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

    private func textDidChange() {
        searchBarTextDidChangeObservable.next(text ?? "")
    }
}

extension ReactiveSearchBar: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textDidChangeDebouncer.call()
    }

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
