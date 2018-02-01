//
//  UIApplication+AddOn.swift
//  HangJia
//
//  Created by Alvin on 16/1/7.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit

extension UIApplication {

	/**
     app BundleName
     */
	func appBundleName() -> String {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
	}

	func appBundleDispalyName() -> String {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
	}

	/**
     app BundleIdentifier
     */
	func appBundleID() -> String {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
	}

	/**
     app BundleShortVersionString
     */
	func appVersion() -> String {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
	}

	/**
     app BundleVersion
     */
	func appBuildVersion() -> String {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
	}

	/**
     UIApplication.sharedApplication().delegate
     
     - returns: AppDelegate
     */
	class func sharedDelegate() -> AppDelegate {
		return UIApplication.shared.delegate as! AppDelegate
	}
}
