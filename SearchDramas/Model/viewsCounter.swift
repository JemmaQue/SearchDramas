//
//  viewsCounter.swift
//  SearchDramas
//
//  Created by Jemma on 2020/12/28.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit

let VIEWS_PLUS_ONE = Notification.Name.init("viewsPlusOne")

class viewsCounter: NSObject {
    
    var views: Int = 0
    
    func viewsPlusOne() {
        views += 1
        NotificationCenter.default.post(name: VIEWS_PLUS_ONE, object: views)
    }

}
