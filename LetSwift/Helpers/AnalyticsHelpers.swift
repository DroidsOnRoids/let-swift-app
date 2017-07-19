//
//  AnalyticsHelpers.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 14.07.2017.
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

#if APP_STORE
import Fabric
import Crashlytics
#else
import HockeySDK
#endif

let analyticsHelper: AnalyticsHelperProtocol = {
#if APP_STORE
    return FabricAnalyticsHelper()
#else
    return HockeyAnalyticsHelper()
#endif
}()

#if APP_STORE
final class FabricAnalyticsHelper: AnalyticsHelperProtocol {
    
    private let disposeBag = DisposeBag()
    
    func setupAnalytics() {
        Fabric.with([Crashlytics.self, Answers.self])
        
        FacebookManager.shared.facebookLoginObservable.subscribeNext { [weak self] in
            self?.reportFacebookLogin()
        }
        .add(to: disposeBag)
    }
    
    func reportFacebookLogin() {
        Answers.logLogin(withMethod: "Facebook", success: true, customAttributes: nil)
    }
    
    func reportOpenEventDetails(id: Int, name: String) {
        Answers.logContentView(withName: name, contentType: "Event details", contentId: "event-\(id)")
    }
    
    func reportOpenSpeakerDetails(id: Int, name: String) {
        Answers.logContentView(withName: name, contentType: "Speaker details", contentId: "speaker-\(id)")
    }
    
    func reportEmailSending(type: String) {
        Answers.logCustomEvent(withName: "Email Sending", customAttributes: ["Topic tag": type])
    }
    
    func reportEventAttendance(id: Int) {
        Answers.logCustomEvent(withName: "Event Attendance", customAttributes: ["Event ID": id])
    }
    
    func reportReminderSet(id: Int) {
        Answers.logCustomEvent(withName: "Reminder Set", customAttributes: ["Event ID": id])
    }
}
#else
final class HockeyAnalyticsHelper: AnalyticsHelperProtocol {
    
    private static let hockeyAppId = "3cc4c0d1fd694100b2d187995356d5ef"
    
    private let disposeBag = DisposeBag()
    
    func setupAnalytics() {
        BITHockeyManager.shared().configure(withIdentifier: HockeyAnalyticsHelper.hockeyAppId)
        BITHockeyManager.shared().start()
        
        if appCompilationCondition == .release {
            BITHockeyManager.shared().authenticator.authenticateInstallation()
        }
    }
}
#endif
