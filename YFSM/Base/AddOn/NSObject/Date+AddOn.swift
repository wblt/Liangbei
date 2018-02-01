//
//  NSDate+Category.swift
//  HangJia
//
//  Created by Alvin on 16/1/28.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import Foundation

let D_DAY: Double = 86400

extension Date {

	/**
     当前时间
     
     - returns: 时间格式: yyyy-MM-dd HH:mm:ss
     */
	static func currentTime() -> String {
		return Date.currentTimeWithFormar("yyyy-MM-dd HH:mm:ss")
	}

	static func currentTimeWithFormar(_ format: String) -> String {
		let formatter: DateFormatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: Date())
	}
	func string(with format: String) -> String {
		let formatter: DateFormatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: self)
	}

	/**
     当前时间戳
     
     - returns: 时间戳
     */
	static func currentTimestamp() -> TimeInterval {

		let date: Date = Date(timeIntervalSinceNow: 0)
		return date.timeIntervalSince1970 * 1000
	}

	/**
     <#Description#>
     
     - returns: <#return value description#>
     */
	func dateWithTimestamp() -> String {
		return String(Int64(self.timeIntervalSince1970 * 1000))
	}

	/**
     当前时间加x天
     
     - parameter dDays: 加x天
     
     - returns: 加x天后的时间
     */
	static func dateWithDaysFromNow(_ days: Int) -> Date {
		return Date().dateByAddingDays(days)
	}

	/**
     当前时间加x天
     
     - parameter dDays: 加x天
     
     - returns: 加x天后的时间
     */
	func dateByAddingDays(_ dDays: Int) -> Date {
		let aTimeInterval: TimeInterval = self.timeIntervalSinceReferenceDate + D_DAY * Double(dDays)
		let newDate: Date = Date(timeIntervalSinceReferenceDate: aTimeInterval)
		return newDate
	}

	/**
     dateFormatter
     
     - returns: yyyy-MM-dd
     */
	func dateFormatter() -> DateFormatter {
		return dateFormatter("yyyy-MM-dd")
	}

	/**
     dateFormatter
     
     - parameter fm: 时间格式 例如: yyyy-MM-dd HH:mm:ss
     
     - returns: NSDateFormatter
     */
	func dateFormatter(_ fm: String) -> DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = fm

		return dateFormatter
	}

	/**
     时间成分
     
     - parameter unit: 日历单位
     
     - returns: 时间成分
     */
	fileprivate func components(_ unit: NSCalendar.Unit) -> DateComponents {
		// 创建日历
		var calendar = Calendar.current
		calendar.locale = Locale(identifier: "zh_CN")
		return (calendar as NSCalendar).components(unit, from: self)
	}
}

extension Date {

	// 从0到6分别表示 周日 到 周六
	var weekDay: Int {
		let weekdayComponents = components(NSCalendar.Unit.weekday)
		return weekdayComponents.weekday! - 1
	}

	/**
     现在时间是某时间后的第几周
     
     - parameter date: 开始的时间
     
     - returns: 现在距离有几周
     */
	func weekofDate(start date: Date) -> Int {

		let dataFormat = DateFormatter()
		dataFormat.dateFormat = "yyyy-MM-dd"

		let dataStr = dataFormat.string(from: date)
		let data1 = dataFormat.date(from: dataStr) // 只拿00点

		let nowDataStr = dataFormat.string(from: self)
		let nowData = dataFormat.date(from: nowDataStr) // 只拿00点

		let subTimeIntervalSince = data1!.timeIntervalSince1970 + TimeInterval((7 - (date.weekDay - 1)) * 86400) // 例如今天星期六，那就要减去两天，然后算是一周
		let totailDay = intervalFromLastDate(Date(timeIntervalSince1970: subTimeIntervalSince), data2: nowData!) + 1// 已经到00点，今天必须加上

		var week = 1
		if totailDay % 7 == 0 {
			week += Int(totailDay / 7)
		} else {
			week += lroundf(Float(totailDay / 7)) + 1
		}

		return week
	}

	/**
     两个世界相差几天（没满24小时不算一天）
     
     - parameter data1: 初始时间
     - parameter data2: 结束时间
     
     - returns: 相差几天
     */
	func intervalFromLastDate(_ data1: Date, data2: Date) -> Int {

		let cal = Calendar.current
		let day = (cal as NSCalendar).components(NSCalendar.Unit.day, from: data1, to: data2, options: NSCalendar.Options(rawValue: 0))

		return day.day!
	}
}

extension Date {

	/// 是否是今年
	var isThisYear: Bool {
		// 取出给定时间的components
		let dateComponents = components(.year)

		// 取出当前时间的components
		let nowComponents = Date().components(.year)

		return dateComponents == nowComponents
	}
}
