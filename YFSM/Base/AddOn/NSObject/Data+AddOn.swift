//
//  NSData+Crypto.swift
//  HangJia
//
//  Created by Alvin on 16/1/27.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import Foundation

extension Data {
    
    /// Data -> Array, Dictionary
    ///
    /// - Returns: Array
    func toArray() -> [Any]? {
        
        return toArrayOrDictionary() as? [Any]
    }
    
    /// Data -> Array, Dictionary
    ///
    /// - Returns: Array
    func toDictionary() -> [String:Any]? {
        
        return toArrayOrDictionary() as? [String:Any]
    }
    
    /// Data -> Array, Dictionary
    ///
    /// - Returns: Any
    fileprivate func toArrayOrDictionary() -> Any? {
        
        do {
            
            let data = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.allowFragments)
            
            return data
        } catch let error {
            
            LogManager.shared.log("\(error)")
            return nil
        }
    }
}
