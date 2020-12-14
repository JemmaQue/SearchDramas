//
//  ApiResult.swift
//  SearchDramas
//
//  Created by Jemma on 2020/12/14.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import Foundation

struct Response: Codable {
    let data: [ResponseData]
}

struct ResponseData: Codable {
    let drama_id: Int
    let name: String
    let total_views: Int
    let created_at: String
    let thumb: String
    let rating: Float
    
    static func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }
}

enum DramaError: Error {
    case networkUnavailable
    case wrongDataFormat
    case insertFailure
    case deleteFailure
    case saveFailure
}
