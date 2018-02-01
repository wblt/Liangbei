//
//  DateValueFormatter.swift
//  YFSMM
//
//  Created by Alvin on 2017/6/20.
//  Copyright © 2017年 Alvin. All rights reserved.
//

import UIKit
import Foundation
import Charts
class DateValueFormatter: NSObject,IAxisValueFormatter {

 
    /// Called when a value from an axis is formatted before being drawn.
    ///
    /// For performance reasons, avoid excessive calculations and memory allocations inside this method.
    ///
    /// - returns: The customized label that is drawn on the x-axis.
    /// - parameter value:           the value that is currently being drawn
    /// - parameter axis:            the axis that the value belongs to
    ///
    
    
    var dateArr = [String]()
    var preFormatter: DateFormatter?
    var needFormatter: DateFormatter?
    
    init(dateArr arr: [Any]) {
        super.init()
        
        dateArr = []
        preFormatter = DateFormatter()
        preFormatter?.dateFormat = "yyyy-MM-dd"
        needFormatter = DateFormatter()
        needFormatter?.dateFormat = "MM.dd"
        
    }
    
    override init() {
        
    }
 


    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        if dateArr.count > 0 {
            let dateStr: String = dateArr[Int(value)]
            let date: Date? = preFormatter?.date(from: dateStr)
            return needFormatter!.string(from: date!)
        }
        return ""
    }


}
