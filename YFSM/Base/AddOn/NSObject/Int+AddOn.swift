//
//  String+Crypto.swift
//  HangJia
//
//  Created by Alvin on 16/1/27.
//  Copyright © 2016年 Alvin. All rights reserved.
//

extension Int {
    
    func moneyDescription() -> String {
        
        let lenght = "\(self)".characters.count
        
        if lenght < 5 { // 万元以内
            return "\(self)"
        } else if lenght < 9 { // 亿以内
            
            let wLevel = (self / 10000)
            let qLevel = String(format: "%.2f", (Float(self).truncatingRemainder(dividingBy: 10000)) / 10000)
            
            return "\(Float(wLevel)+Float(qLevel)!)万"
        } else {
            
            return "\(self/100000000)亿"
        }
    }
}
