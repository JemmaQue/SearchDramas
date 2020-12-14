//
//  AuthAPI.swift
//  SearchDramas
//
//  Created by Jemma on 2020/12/14.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import Foundation

class AuthAPI {
    private init() {}
    static let shared = AuthAPI()
    
    func requestAccessToken() -> AuthStatus {
        return .AccessTokenValid
    }
    
    func refreshAccessToken() -> AuthStatus {
        return .AccessTokenExpired
    }
    
    func verifyAccessToken() -> AuthStatus {
        return .AccessTokenValid
    }
    
    func revokeAccessToken() {
        /// logout
    }
}
