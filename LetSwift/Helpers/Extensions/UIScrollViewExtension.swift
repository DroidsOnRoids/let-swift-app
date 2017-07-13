//
//  UIScrollViewExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 27.05.2017.
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

extension UIScrollView {
    func addPullToRefresh(callback: @escaping () -> ()) {
        es_addPullToRefresh(animator: PullToRefreshAnimator(), handler: callback)
    }

    func removePullToRefresh() {
        es_removeRefreshHeader()
    }
    
    func finishPullToRefresh() {
        es_stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
    }
}
