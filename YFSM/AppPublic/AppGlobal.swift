//
//  AppGlobal.swift
//  HangJia
//
//  Created by Alvin on 16/1/7.
//  Copyright © 2016年 Alvin. All rights reserved.
//  全局

import Foundation
import UIKit

class AppGlobal: NSObject {
    
    class func initGlobal() {
        
        //		ThemeManager.setTheme("Blue", path: .MainBundle)
        //		 status bar
        //		SkinManager.sharedInstance().switchTo(SkinStyle.Blue)
        //		let statusPicker = ThemeStatusBarStylePicker(keyPath: "UIStatusBarStyle")
        //		UIApplication.sharedApplication().theme_setStatusBarStyle(statusPicker, animated: true)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        // 导航栏按钮
        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17)]
        

        
        //navigationBar.backIndicatorImage = UIImage(named: "back")
        
        //navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationBar.setBackgroundImage(UIImage(named: "system-navcb"), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        
        
    }
}
