//
//  FacebookManager.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 20.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import FBSDKLoginKit

enum FacebookLoginStatus {
    case success(FBSDKLoginManagerLoginResult)
    case error(Error?)
    case cancelled
}

enum FacebookEventAttendance: String {
    case unknown
    case attending
    case declined
    case maybe
}

fileprivate enum FacebookPermissions {
    static let rsvpEvent = "rsvp_event"
}

fileprivate enum FacebookError: Int {
    case missingPermissions = 200
    case missingExtendedPermissions = 299 // HACK: Undocumented status code
    
    static func from(error: Error?) -> FacebookError? {
        guard let errorCode = (error as NSError?)?.userInfo[FBSDKGraphRequestErrorGraphErrorCode] as? Int else { return nil }

        return FacebookError(rawValue: errorCode)
    }
}

final class FacebookManager {
    
    static let shared = FacebookManager()
    private let loginManager = FBSDKLoginManager()
    
    private let readPermissions = [String]()
    private let publishPermissions = [FacebookPermissions.rsvpEvent]
    
    let facebookLogoutObservable = Observable<Void>()
    
    private init() {}
    
    var isLoggedIn: Bool {
        return FBSDKAccessToken.current() != nil
    }
    
    func logIn(from viewController: UIViewController?, callback: ((FacebookLoginStatus) -> Void)?) {
        let handler = { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            if let error = error {
                callback?(.error(error))
            } else if let result = result {
                result.isCancelled ? callback?(.cancelled) : callback?(.success(result))
            } else {
                callback?(.error(nil))
            }
        }
        
        if readPermissions.isEmpty || isLoggedIn {
            loginManager.logIn(withPublishPermissions: publishPermissions,
                               from: viewController,
                               handler: handler)
        } else {
            loginManager.logIn(withReadPermissions: readPermissions,
                               from: viewController,
                               handler: handler)
        }
    }
    
    func logOut() {
        loginManager.logOut()
        
        facebookLogoutObservable.next()
    }
    
    private func askForMissingPermissions(error: FacebookError?, callback: @escaping (Bool) -> Void) {
        guard let error = error, [FacebookError.missingPermissions, FacebookError.missingExtendedPermissions].contains(error) else {
            callback(false)
            return
        }
        
        self.logIn(from: nil) { status in
            if case .success(_) = status {
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    private func sendGraphRequest(_ request: FBSDKGraphRequest, callback: @escaping (Any?) -> Void) {
        request.start { [unowned self] (_, result: Any?, error: Error?) in
            self.askForMissingPermissions(error: FacebookError.from(error: error)) { recovered in
                guard recovered else {
                    callback(result)
                    return
                }
                
                request.start(completionHandler: { (_, result: Any?, error: Error?) in
                    callback(result)
                })
            }
        }
    }
    
    func changeEvent(attendanceTo attendance: FacebookEventAttendance, forId id: String, callback: ((Bool) -> Void)?) {
        // HACK: Undocumented API call
        guard let request = FBSDKGraphRequest(graphPath: "\(id)/\(attendance)", parameters: [:], httpMethod: "POST") else {
            callback?(false)
            return
        }
        
        sendGraphRequest(request) { result in
            guard let resultDict = (result as? [String : Any]) else {
                callback?(false)
                return
            }
            
            let success = resultDict["success"] as? Bool
            callback?(success == true)
        }
    }
    
    private func attendanceRequest(forEventId id: String) -> FBSDKGraphRequest? {
        guard isLoggedIn else { return nil }
        let parameters: [AnyHashable : Any] = [
            "user" : FBSDKAccessToken.current().userID,
            "fields" : "rsvp_status"
        ]
        
        return FBSDKGraphRequest(graphPath: "\(id)/\(FacebookEventAttendance.attending)", parameters: parameters, httpMethod: "GET")
    }
    
    func isUserAttending(toEventId id: String, callback: @escaping (FacebookEventAttendance) -> Void) {
        guard let request = attendanceRequest(forEventId: id) else {
            callback(.unknown)
            return
        }
        
        sendGraphRequest(request) { result in
            guard let resultDict = (result as? [String : Any]), let data = resultDict["data"], let dataArray = (data as? [Any]) else {
                callback(.unknown)
                return
            }
            
            callback(dataArray.isEmpty ? .declined : .attending)
        }
    }
}
