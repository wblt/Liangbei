//
//  AppDelegate.swift
//  YFSMM
//
//  Created by Alvin on 2017/6/16.
//  Copyright © 2017年 Alvin. All rights reserved.
//

import UIKit


@UIApplicationMain
@objc class AppDelegate: UIResponder, UIApplicationDelegate,UIAlertViewDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
       // window?.rootViewController = ViewController()
        
        // 得到当前应用的版本号
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 取出之前保存的版本号
        let userDefaults = UserDefaults.standard
        let appVersion = userDefaults.string(forKey: "appVersion")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 如果 appVersion 为 nil 说明是第一次启动；如果 appVersion 不等于 currentAppVersion 说明是更新了
        if appVersion == nil || appVersion != currentAppVersion {
            let guideViewController = storyboard.instantiateViewController(withIdentifier: "GuideViewController") as! GuideViewController
            self.window?.rootViewController = guideViewController
        } else {
            if AccountManager.shared.isLogin() {
                let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                self.window?.rootViewController = BaseNavC(rootViewController: homeVC)
            }else {
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                
                self.window?.rootViewController = BaseNavC(rootViewController: loginVC)
            }
        }
        _ = BaseRequest.shared
        _ = DeviceManager.shared
        AppGlobal.initGlobal()
        
        checkNewVersion();
        window?.makeKeyAndVisible()
        return true
    }

    func checkNewVersion() {
        
        weak var weakSelf = self;
        
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"];
        
        let net = NetWork.init();
        
        if currentVersion != nil {
        
            print(currentVersion!);
            
            net.getTheNewVersion();
                
            net.checkVisionBK={(newVwrsion) in
                
                let version_new = newVwrsion!;
                
                let version_current = currentVersion as! String;
                
                
                print("当前版本号",version_new);
                if version_new > version_current {
//                    let alter = UIAlertView.init(title: "版本更新", message: "有新的版本啦！", delegate: weakSelf, cancelButtonTitle: "更新", otherButtonTitles: "忽略");
//                    
//                    alter.show();
                }
                
            }
        }
    }
    
    
    //跳转APPStore
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        switch buttonIndex {
        case 0:
            
            print("更新");
            
            let urlString = "itms-apps://itunes.apple.com/app/id1281243324"
            if let url = URL(string: urlString) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }        default:
            
            print("忽略");

        }
    
    }
   
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

