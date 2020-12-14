//
//  AccessToken.swift
//  SearchDramas
//
//  Created by Jemma on 2020/12/14.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import Foundation

enum AuthStatus: Int {
    case AccessTokenValid
    case AccessTokenInValid
}

struct AccessToken {
    let value: String
    let createdAt: Date
    let expiresIn: TimeInterval
    let refreshToken: String
    
}
