//
//  UIDevice+AddOn.swift
//  HangJia
//
//  Created by Alvin on 16/1/7.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {

	/// 是否是模拟器
	var isSimulator: Bool {
		let simu = deviceModel == .Simulator
		return simu
	}

	/// 是否越狱
	var isJailBroken: Bool {
		#if TARGET_IPHONE_SIMULATOR
			return false
		#else
			var isJailbroken = false
			let cydiaInstalled: Bool = FileManager.default.fileExists(atPath: "/Applications/Cydia.app")

			let fileHandle: UnsafeMutablePointer<FILE> = fopen("/bin/bash", "r")

			if (!(errno == ENOENT) && cydiaInstalled) {
				// Device is jailbroken
				isJailbroken = true;
			}
			fclose(fileHandle);

			return isJailbroken
		#endif
	}

	/// 设备类型uuid
	var uuid: String {
		let uuid_ref = CFUUIDCreate(nil)
		let uuid_string_ref = CFUUIDCreateString(nil, uuid_ref);
		let uuid = uuid_string_ref as! String

		return uuid
	}

	/// 设备类型
	var deviceModel: DeviceModel {

		var systemInfo = utsname()
		uname(&systemInfo)
		let modelCode = withUnsafeMutablePointer(to: &systemInfo.machine) {
			ptr in String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
		}

		var modelMap: [String: DeviceModel] = [
			"i386": .Simulator,
			"x86_64": .Simulator,
			"Watch1,1": .AppleWatch,
			"Watch1,2": .AppleWatch,

			"iPod1,1": .iPod1,
			"iPod2,1": .iPod2,
			"iPod3,1": .iPod3,
			"iPod4,1": .iPod4,
			"iPod5,1": .iPod5,
			"iPod7,1": .iPod6,

			"iPad1,1": .iPad1,
			"iPad2,1": .iPad2_WIFI,
			"iPad2,2": .iPad2_GSM,
			"iPad2,3": .iPad2_CDMA,
			"iPad2,4": .iPad2,
			"iPad2,5": .iPadMini1,
			"iPad2,6": .iPadMini1,
			"iPad2,7": .iPadMini1,

			"iPad3,1": .iPad3_WIFI,
			"iPad3,2": .iPad3_4G,
			"iPad3,3": .iPad3_4G,
			"iPad3,4": .iPad4,
			"iPad3,5": .iPad4,
			"iPad3,6": .iPad4,
			"iPad4,1": .iPadAir1,
			"iPad4,2": .iPadAir1,
			"iPad4,3": .iPadAir1,
			"iPad4,4": .iPadMini2,
			"iPad4,5": .iPadMini2,
			"iPad4,6": .iPadMini2,
			"iPad4,7": .iPadMini3,
			"iPad4,8": .iPadMini3,
			"iPad4,9": .iPadMini3,
			"iPad5,1": .iPadMini4,
			"iPad5,2": .iPadMini4,
			"iPad5,3": .iPadAir2,
			"iPad5,4": .iPadAir2,

			"iPhone1,1": .iPhone1G,
			"iPhone1,2": .iPhone3G,
			"iPhone2,1": .iPhone3GS,
			"iPhone3,1": .iPhone4_GSM,
			"iPhone3,2": .iPhone4,
			"iPhone3,3": .iPhone4_CDMA,
			"iPhone4,1": .iPhone4S,
			"iPhone5,1": .iPhone5,
			"iPhone5,2": .iPhone5,
			"iPhone5,3": .iPhone5C,
			"iPhone5,4": .iPhone5C,
			"iPhone6,1": .iPhone5S,
			"iPhone6,2": .iPhone5S,
			"iPhone7,1": .iPhone6plus,
			"iPhone7,2": .iPhone6,
			"iPhone8,1": .iPhone6S,
			"iPhone8,2": .iPhone6Splus,
			"iPhone8,4": .iPhone5SE
		]

		if let model = modelMap[String(modelCode)] {
			return model
		}

		return DeviceModel.Unrecognized
	}

}

public enum DeviceModel: String {
	case Simulator = "Simulator/Sandbox",
		AppleWatch = "Apple Watch",
		iPod1 = "iPod 1",
		iPod2 = "iPod 2",
		iPod3 = "iPod 3",
		iPod4 = "iPod 4",
		iPod5 = "iPod 5",
		iPod6 = "iPod 6",

		iPad1 = "iPad 1",
		iPad2_WIFI = "iPad 2 (WIFI)",
		iPad2_GSM = "iPad 2 (GSM)",
		iPad2_CDMA = "iPad 2 (CDMA)",
		iPad2 = "iPad 2",
		iPad3_WIFI = "iPad 3 (WIFI)",
		iPad3_4G = "iPad 3 (4G)",
		iPad4 = "iPad 4",

		iPhone1G = "iPhone 1G",
		iPhone3G = "iPhone 3G",
		iPhone3GS = "iPhone 3GS",
		iPhone4_GSM = "iPhone 4 (GSM)",
		iPhone4_CDMA = "iPhone 4 (CDMA)",
		iPhone4 = "iPhone 4",
		iPhone4S = "iPhone 4S",
		iPhone5 = "iPhone 5",
		iPhone5S = "iPhone 5S",
		iPhone5C = "iPhone 5C",
		iPhone6 = "iPhone 6",
		iPhone6plus = "iPhone 6 Plus",
		iPhone6S = "iPhone 6S",
		iPhone6Splus = "iPhone 6S Plus",
		iPhone5SE = "iPhone 5SE",

		iPadMini1 = "iPad Mini 1",
		iPadMini2 = "iPad Mini 2",
		iPadMini3 = "iPad Mini 3",
		iPadMini4 = "iPad Mini 4",
		iPadAir1 = "iPad Air 1",
		iPadAir2 = "iPad Air 2",
		Unrecognized = "未知的ios设备"
}
