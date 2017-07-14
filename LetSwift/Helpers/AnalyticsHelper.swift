//
//  AnalyticsHelper.swift
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

class AnalyticsHelper {
    
    static let shared: AnalyticsHelper = {
        #if APP_STORE
        return FabricAnalyticsHelper()
        #else
        return HockeyAnalyticsHelper()
        #endif
    }()
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate init() {
        FacebookManager.shared.facebookLoginObservable.subscribeNext { [weak self] in
            self?.reportFacebookLogin()
        }
        .add(to: disposeBag)
    }
    
    func setupAnalytics() { }
    func reportFacebookLogin() { }
    func reportOpenEventDetails(id: Int) { }
    func reportOpenSpeakerDetails(id: Int) { }
    func reportEmailSending(type: String) { }
    func reportEventAttendance(id: Int) { }
    func reportReminderSet(id: Int) { }
}

#if APP_STORE
final class FabricAnalyticsHelper: AnalyticsHelper {
    
    override func setupAnalytics() {
        Fabric.with([Crashlytics.self, Answers.self])
    }
    
    override func reportFacebookLogin() {
        Answers.logLogin(withMethod: "Facebook", success: true, customAttributes: nil)
    }
    
    override func reportOpenEventDetails(id: Int) {
        Answers.logContentView(withName: "Event \(id)", contentType: "Event details", contentId: "event-\(id)")
    }
    
    override func reportOpenSpeakerDetails(id: Int) {
        Answers.logContentView(withName: "Speaker \(id)", contentType: "Speaker details", contentId: "speaker-\(id)")
    }
    
    override func reportEmailSending(type: String) {
        Answers.logCustomEvent(withName: "Email Sending", customAttributes: ["Topic tag": type])
    }
    
    override func reportEventAttendance(id: Int) {
        Answers.logCustomEvent(withName: "Event Attendance", customAttributes: ["Event ID": id])
    }
    
    override func reportReminderSet(id: Int) {
        Answers.logCustomEvent(withName: "Reminder Set", customAttributes: ["Event ID": id])
    }
}
#else
final class HockeyAnalyticsHelper: AnalyticsHelper {
    
    override func setupAnalytics() {
        BITHockeyManager.shared().configure(withIdentifier: hockeyAppId)
        BITHockeyManager.shared().start()
        
        if appCompilationCondition == .release {
            BITHockeyManager.shared().authenticator.authenticateInstallation()
        }
    }
}
#endif
