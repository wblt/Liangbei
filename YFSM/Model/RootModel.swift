//
//  BaseModel.swift
//  demo-swift
//
//  Created by Alvin on 16/4/9.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit

class RootModel {
    
    var status: Int!
    var message: String!
    var hasMore = false
    var result: Any!
    
    init(){}
    
    init?(dic: [String : Any]) {
        status = dic["status"] as? Int
        message = dic["message"] as? String
        result = dic["result"]
    
        if let isMore = dic["isMore"] as? Int {
            hasMore = (isMore == 1)
        }
    }
}
