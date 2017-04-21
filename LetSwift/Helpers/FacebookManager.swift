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

final class FacebookManager {
    
    static let shared = FacebookManager()
    private let loginManager = FBSDKLoginManager()
    
    private let readPermissions = [String]()
    private let publishPermissions = [String]()
    
    private init() {}
    
    var isLoggedIn: Bool {
        return FBSDKAccessToken.current() != nil
    }
    
    func logIn(from viewController: UIViewController, callback: ((FacebookLoginStatus) -> Void)?) {
        let handler = { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            if let error = error {
                callback?(.error(error))
            } else if let result = result {
                result.isCancelled ? callback?(.cancelled) : callback?(.success(result))
            } else {
                callback?(.error(nil))
            }
        }
        
        if publishPermissions.isEmpty {
            loginManager.logIn(withReadPermissions: readPermissions,
                               from: viewController,
                               handler: handler)
        } else {
            loginManager.logIn(withPublishPermissions: publishPermissions,
                               from: viewController,
                               handler: handler)
        }
    }
    
    func logOut() {
        loginManager.logOut()
    }
}
