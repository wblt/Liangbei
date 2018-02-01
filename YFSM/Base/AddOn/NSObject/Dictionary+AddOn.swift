//
//  Dictionary+AddOn.swift
//  DigitalCampus
//
//  Created by blueskyplan on 16/8/11.
//  Copyright © 2016年 luo. All rights reserved.
//

import Foundation

func + <K, V>(left: Dictionary<K, V>, right: Dictionary<K, V>) -> Dictionary<K, V> {
    var map = Dictionary<K, V>()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}

func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

extension Dictionary {
    
    /**
     Dictionary -> Array, Dictionary
     */
    func toString() -> String? {
        
        do {
            
            let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            let str = String(data: data, encoding: String.Encoding.utf8)
            
            return str
        } catch let error {
            
            LogManager.shared.log("\(error)")
            return nil
        }
    }
}
