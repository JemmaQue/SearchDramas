//
//  AuthHelper.swift
//  SearchDramas
//
//  Created by Jemma on 2020/12/14.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit

class AuthHelper {
        
    func fetchAccessToken() {
        if AccessTokenStore.shared.accessToken == nil {
            if AuthAPI.shared.requestAccessToken() == AccessTokenInValid {
                print("request access token fail")
            }
            return
        }
        
        if AuthAPI.shared.verifyAccessToken() == .AccessTokenValid {
            return
        }
        
        print("verify access token fail")
        if AuthAPI.shared.refreshAccessToken() == .AccessTokenValid {
            return
        }
        
        print("refresh access token fail")
        if AuthAPI.shared.requestAccessToken() == .AccessTokenInValid {
            print("request access token fail")
            return
        }
        print("request access token ok")
    }
    
}
