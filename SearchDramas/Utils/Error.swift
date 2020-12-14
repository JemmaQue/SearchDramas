//
//  Error.swift
//  SearchDramas
//
//  Created by Jemma on 2020/12/14.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import Foundation

extension Error {
    func errorMessage() -> String {
        let error = self as NSError
        return error.localizedDescription
    }
}
