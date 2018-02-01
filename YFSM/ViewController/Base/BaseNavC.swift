//
//  BaseNavC.swift
//  HangJia
//
//  Created by Alvin on 16/1/8.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit

class BaseNavC: UINavigationController {

    // MARK: - life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}

//	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//		
//        if self.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
//			
//            if self.interactivePopGestureRecognizer != nil {
//				
//                self.interactivePopGestureRecognizer!.isEnabled = false
//			}
//		}
//        
//		super.pushViewController(viewController, animated: animated)
//	}
//
//	override func show(_ vc: UIViewController, sender: Any?) {
//		
//        if self.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
//			
//            if self.interactivePopGestureRecognizer != nil {
//				
//                self.interactivePopGestureRecognizer!.isEnabled = true
//			}
//		}
//
//        super.show(vc, sender: sender)
//	}

	override var preferredStatusBarStyle : UIStatusBarStyle {
       
        return .lightContent
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
        
	}
}
