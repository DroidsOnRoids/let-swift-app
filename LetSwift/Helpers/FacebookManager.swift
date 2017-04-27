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
    case attending
    case declined
    case maybe
}

fileprivate enum FacebookPermissions {
    static let rsvpEvent = "rsvp_event"
    static let userEvents = "user_events"
}

fileprivate enum FacebookErrorCodes {
    static let missingPermissions = 200
    static let missingExtendedPermissions = 299 // HACK: Undocumented status code
}

final class FacebookManager {
    
    static let shared = FacebookManager()
    private let loginManager = FBSDKLoginManager()
    
    private let readPermissions = [String]()
    private let publishPermissions = [FacebookPermissions.rsvpEvent]
    
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
    }
    
    private func askForMissingPermissions(error: Error?, callback: @escaping (Bool) -> Void) {
        if let error = error, let errorCode = (error as NSError).userInfo[FBSDKGraphRequestErrorGraphErrorCode] as? Int, errorCode == FacebookErrorCodes.missingPermissions || errorCode == FacebookErrorCodes.missingExtendedPermissions {
            self.logIn(from: nil) { status in
                if case .success(_) = status {
                    callback(true)
                } else {
                    callback(false)
                }
            }
        } else {
            callback(false)
        }
    }
    
    private func sendGraphRequest(_ request: FBSDKGraphRequest, callback: @escaping (Any?) -> Void) {
        request.start(completionHandler: { (_, result: Any?, error: Error?) in
            self.askForMissingPermissions(error: error) { recovered in
                if recovered {
                    request.start(completionHandler: { (_, result: Any?, error: Error?) in
                        callback(result)
                    })
                } else {
                    callback(result)
                }
            }
        })
    }
    
    func changeEvent(attendanceTo attendance: FacebookEventAttendance, forId id: String, callback: ((Bool) -> Void)?) {
        // HACK: Undocumented API call
        guard let request = FBSDKGraphRequest(graphPath: "\(id)/\(attendance)", parameters: [:], httpMethod: "POST") else { callback?(false); return }
        
        sendGraphRequest(request) { result in
            guard let result = result, let resultDict = (result as? [String : Any]) else { callback?(false); return }
            
            if let success = resultDict["success"], success as? Bool == true {
                callback?(true)
            } else {
                callback?(false)
            }
        }
    }
    
    func isUserAttending(toEventId id: String, callback: @escaping (Bool) -> Void) {
        guard let request = FBSDKGraphRequest(graphPath: "\(id)/\(FacebookEventAttendance.attending)", parameters: ["user" : FBSDKAccessToken.current().userID], httpMethod: "GET") else { return }
        
        sendGraphRequest(request) { result in
            guard let result = result, let resultDict = (result as? [String : Any]) else { return }
            guard let data = resultDict["data"], let dataArray = (data as? [Any]) else { return }
            
            callback(!dataArray.isEmpty)
        }
    }
}
