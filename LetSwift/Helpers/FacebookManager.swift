//
//  FacebookManager.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 20.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import FBSDKLoginKit

struct FacebookManager {
    
    static var shared = FacebookManager()
    private let loginManager = FBSDKLoginManager()
    
    private let readPermissions = [String]()
    private let publishPermissions = [String]()
    
    enum FacebookLoginStatus {
        case success
        case error
        case cancelled
    }
    
    var isLoggedIn: Bool {
        return FBSDKAccessToken.current() != nil
    }
    
    func logIn(from viewController: UIViewController, callback: ((FacebookLoginStatus) -> Void)?) {
        let handler = { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            if error != nil {
                callback?(.error)
            } else {
                // according to the documentation, result is never nil
                if result!.isCancelled {
                    callback?(.cancelled)
                } else {
                    callback?(.success)
                }
            }
        }
        
        if !publishPermissions.isEmpty {
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
}
