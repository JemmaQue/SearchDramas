//
//  AccessTokenStore.swift
//  SearchDramas
//
//  Created by Jemma on 2020/12/14.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import Foundation

class AccessTokenStore {
    private init() {}
    static let shared = AccessTokenStore()
    
    var current: AccessToken?
    
    func saveCurrentToken(_ token: AccessToken) {
       /// keychainStore
    }
    
    func removeCurrentAccessToken() {
        
    }
}
