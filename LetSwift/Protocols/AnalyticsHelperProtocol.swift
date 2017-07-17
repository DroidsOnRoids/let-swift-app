//
//  AnalyticsHelperProtocol.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 17.07.2017.
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

import Foundation

@objc protocol AnalyticsHelperProtocol {
    func setupAnalytics()
    @objc optional func reportFacebookLogin()
    @objc optional func reportOpenEventDetails(id: Int)
    @objc optional func reportOpenSpeakerDetails(id: Int)
    @objc optional func reportEmailSending(type: String)
    @objc optional func reportEventAttendance(id: Int)
    @objc optional func reportReminderSet(id: Int)
}
