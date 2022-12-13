//
//  FacebookManager.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 20.04.2017.
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

enum FacebookLoginStatus {
    case success
    case error(Error?)
    case cancelled
}

enum FacebookEventAttendance: String {
    case unknown
    case attending
    case declined
    case maybe
}

final class FacebookManager {
    
    static let shared = FacebookManager()

    let facebookLoginObservable = Observable<Void>()
    let facebookLogoutObservable = Observable<Void>()
    
    var isLoggedIn: Bool {
        return false
    }
    
    func logIn(from viewController: UIViewController?, callback: ((FacebookLoginStatus) -> Void)?) {
        facebookLoginObservable.next()
        callback?(.success)
    }
    
    func logOut() {
        facebookLogoutObservable.next()
    }
    
    func changeEvent(attendanceTo attendance: FacebookEventAttendance, forId id: String, callback: ((Bool) -> Void)?) {
        callback?(true)
    }
    
    func isUserAttending(toEventId id: String, callback: @escaping (FacebookEventAttendance) -> Void) {
        callback(.unknown)
    }
}
