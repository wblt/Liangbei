//
//  StoryboardManager.swift
//  DigitalCampus
//
//  Created by luo on 16/4/19.
//  Copyright © 2016年 luo. All rights reserved.
//

import UIKit

class StoryboardManager {
    
    /**
     通过故事版拿到VC
     
     - parameter storyboardName: 用法：StoryboardManager.storyboardWithName("sbid")("vcid") as vc
     
     - returns: vc
     */
    class func storyboard(with name:String) -> ((String) -> AnyObject?) {
        
        return {(identifier: String) -> AnyObject? in UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)}
    }
    
}
