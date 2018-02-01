//
//  AppConst.swift
//  HangJia
//
//  Created by Alvin on 16/1/7.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import Foundation
import UIKit
//MARK: - Tip
let tipNetError   = "您的网络好像有点问题"
let tipNetTimeOut = "请求超时"
let tipLoading    = "正在加载"


//MARK: - URL
let cProductionDomainUrl = "http://ncvt.yundousi.com:8080/doby"
let cTestDomainUrl       = "http://192.168.1.20"

// 服务器环境
// let api_service = "http://120.26.104.21/tpiot/app";
let api_service = "http://120.26.104.21/tpiot/app";

let cApiVersionV1 = ""

let cAPPStoreID  = 1066760920
let cShareAPPURL = "http://www.ncvt.net/"
let cAPPStoreURL = "https://itunes.apple.com/cn/app/yun-dou-si-shu-zi-xiao-yuan/id\(cAPPStoreID)?mt=8"


//MARK: - iRate 评价
let cIRateAppID: UInt = UInt(cAPPStoreID)
let cIRateAppBundleID = Bundle.main.bundleIdentifier!


//MARK: - 颜色
let themeColor = UIColorHex("#2594E0")
let cBackgroundColor = UIColorHex("#f5f5f5")


//MARK: - 第三方SDK
/// 个推
let cGeTui_Test_AppId           = "RcSNxudaic8vwwxsfgGfM8"
let cGeTui_Test_AppKey          = "c0ylHdqCg878j09iaIK30A"
let cGeTui_Test_AppSecret       = "rTDrmdNpWR8qwOClqjtlx6"
let cGeTui_Dis_AppId            = "RcSNxudaic8vwwxsfgGfM8"
let cGeTui_Dis_AppKey           = "c0ylHdqCg878j09iaIK30A"
let cGeTui_Dis_AppSecret        = "rTDrmdNpWR8qwOClqjtlx6"
let cGeTui_AppStore_AppId       = "iHI5jK1G7q6qUc0xfBLuU3"
let cGeTui_AppStore_AppKey      = "LfvVq5JLWWAaFyqMxryeB8"
let cGeTui_AppStore_AppSecret   = "hHF4lW1IWhAcq6QWdazXqA"

/// 融云IM
let cRongCloud_Test_AppKey      = "qf3d5gbj3m1sh"
let cRongCloud_Dis_AppKey       = "c9kqb3rdkhwyj"
let cRongCloud_AppStore_AppKey  = "82hegw5uh8knx"

/// 友盟应用分析SDK
let cMobClick_Test_AppKey       = "57c93cc567e58e8789000568"
let cMobClick_Dis_AppKey        = "57c93ce8e0f55aac09001bd6"
let cMobClick_AppStore_AppKey   = "58b81419bbea835d31000e65"

/// QQ Share SDK QQ
let cQQConnect_Test_AppKey          = "1105607119"
let cQQConnect_Test_AppSecret       = "m4oB6RYHncysMZHN"
let cQQConnect_Dis_AppKey           = "1105607133"
let cQQConnect_Dis_AppSecret        = "UR3HrnSPokLWNWM4"
let cQQConnect_AppStore_AppKey      = "1105920241"
let cQQConnect_AppStore_AppSecret   = "HF9eXItj59CxHxQA"
let cQQConnect_URL                  = "http://www.ncvt.net/"

/// Weixin SDK 微信
let cWeixin_Test_AppID          = "wxb88c3893d407657b"
let cWeixin_Test_AppSecret      = "3b9decac886b3481d6a81c8388802647"
let cWeixin_Dis_AppID           = "wx00a4312318abe32e"
let cWeixin_Dis_AppSecret       = "2cddd9b3695e405db67f1318991e9e91"
let cWeixin_AppStore_AppID      = "wx4091ec9c70298938"
let cWeixin_AppStore_AppSecret  = "d809380a96684df357f0802e9aa61d8b"
let cWeixin_URL                 = "http://www.ncvt.net/"

/// Sina Weibo SDK 微博
//let cSinaWeibo_Dis_AppKey = "1722407330"
//let cSinaWeibo_Dis_AppSecret = "6a9b201a0d51daf6a4f46aed18b3adf6"
//let cSinaWeibo_Test_AppKey = "2388465224"
//let cSinaWeibo_Test_AppSecret = "71acf50835553b233ebdba44d477dfd4"
//let cSinaWeibo_AppStore_AppKey = "1341895482"
//let cSinaWeibo_AppStore_AppSecret = "5d6e64e5024406b003d84855a1268215"
//let cSinaWeibo_URL = ""


//MARK: - 全局默认
/// 默认图片（1：1）
let PlaceholderImage = UIImage(named: "placeholder_image")
/// 默认图片（长方形）
let PlaceholderImage_L = UIImage(named: "placeholder_image_long")
/// 默认错误图片
let ErrorImage = UIImage(named: "netError")


//MARK: - NotifyCenter
let cNTabbarBadgeValue      = "cNTabbarBadgeValue"// 设置tabbar角标
//let cNNetFail             = "cNNetFail"// 网络失败
let cNNetSuccess            = "cNNetSuccess"// 网络成功
let cNShouldLogin           = "cNShouldLogin"// 需要登录
let cNDidLogin              = "cNDidLogin"// 登录
let cNDidLogout             = "cNDidLogout"// 登出
let cNRefreshUserInfo       = "cNRefreshUserInfo"// 刷新用户信息


//MARK: - Color颜色
/// 支持"#"和"0x"开头
func UIColorHex(_ hex: String) -> UIColor {
    
    return hex.colorWithHexString
}

// 正常RBG
func UIColorRGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return UIColor(red: (r) / 255.0, green: (g) / 255.0, blue: (b) / 255.0, alpha: 1)
}

func UIColorRGBHex(_ rgbValue: UInt) -> UIColor {
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF >> 0) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//MARK: - 系统相关
let iPhone4     = UIScreen.main.scale == 2.0 && UIScreen.main.bounds.size.height == 480.0
let iPhone5     = UIScreen.main.scale == 2.0 && UIScreen.main.bounds.size.height == 568.0
let iPhone6     = UIScreen.main.scale == 2.0 && UIScreen.main.bounds.size.height == 667.0
let iPhone6Plus = UIScreen.main.scale == 3.0 && UIScreen.main.bounds.size.height == 736.0

/// 屏幕Frame
let kScreenFrame = UIScreen.main.bounds
/// 屏幕Width
let kScreenFrameW = UIScreen.main.bounds.width
/// 屏幕Height
let kScreenFrameH = UIScreen.main.bounds.size.height

/// 状态栏Frame
let kStatusBarFrame = UIApplication.shared.statusBarFrame
/// 状态栏高
let kStatusBarInverseH = (UIApplication.shared.statusBarFrame.height / autoY)

/// 1像素高
let kAPixelHeight = 1 / UIScreen.main.scale


//官方默认参数
let kDefaultGrayColor: UInt = 0xC8C7CC
let kStatusH: CGFloat = 20
let kNavH: CGFloat = 44
let kNavHorizontalH: CGFloat = 32
let kSearchBarH: CGFloat = 43
let kSearchBarWithTitleH: CGFloat = 74
//#define kTabBarH 49
let kTabBarH: CGFloat = 60 // 起货定制Tabbar
let kToolBarH: CGFloat = 44
let kTableCellH: CGFloat = 43
let kTableCellBlankW: CGFloat = 15
let kTableCellMarginAccessoryRight: CGFloat = (15 + 15)

let kAlertW: CGFloat = 270
let kActionSheetW: CGFloat = (kScreenFrameW - 16)
let kActionSheetCellH: CGFloat = 44
let kEditMenuH: CGFloat = 36
let kPopoverW: CGFloat = 320
let kSwitchW: CGFloat = 51
let kSwitchH: CGFloat = 31
let kSegmentControllerH: CGFloat = 29

let kNavButtonItemCustomOffset: CGFloat = 12


//美工效果图 以 “iphone 5”为标准
let k320: CGFloat = 320.0// 逻辑宽度
let k640: CGFloat = 640.0// 逻辑高度
let autoX = (kScreenFrameW / k320)
let autoY = (kScreenFrameH / k640)

/// 根据宽度适配高度
func ConvertToBigScreen(_ w: CGFloat) -> CGFloat {
    return autoX * w
}

////首次启动app
//let kFirstLaunch = "firstLaunch\(Bundle.main.infoDictionary!["CFBundleShortVersionString"])"
//
////官方默认参数
//let kDefaultGrayColor: UInt = 0xC8C7CC
//let kStatusH: CGFloat = 20
//let kNavH: CGFloat = 44
//let kNavHorizontalH: CGFloat = 32
//let kSearchBarH: CGFloat = 43
//let kSearchBarWithTitleH: CGFloat = 74
////#define kTabBarH 49
//let kTabBarH: CGFloat = 60 // 起货定制Tabbar
//let kToolBarH: CGFloat = 44
//let kTableCellH: CGFloat = 43
//let kTableCellBlankW: CGFloat = 15
//let kTableCellMarginAccessoryRight: CGFloat = (15 + 15)
//
//let kAlertW: CGFloat = 270
//let kActionSheetW: CGFloat = (kScreenFrameW - 16)
//let kActionSheetCellH: CGFloat = 44
//let kEditMenuH: CGFloat = 36
//let kPopoverW: CGFloat = 320
//let kSwitchW: CGFloat = 51
//let kSwitchH: CGFloat = 31
//let kSegmentControllerH: CGFloat = 29
//
//let kNavButtonItemCustomOffset: CGFloat = 12


