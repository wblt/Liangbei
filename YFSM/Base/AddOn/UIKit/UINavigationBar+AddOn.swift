//
//  UINavigationBarExt.swift
//  TestExtension
//
//  Created by blueskyplan on 16/8/19.
//  Copyright © 2016年 luo. All rights reserved.
//

import UIKit

extension UINavigationBar {

	func hideBottomHairline() {
		let navigationBarImageView = hairlineImageViewInNavigationBar(self)
		navigationBarImageView!.isHidden = true
	}

	func showBottomHairline() {
		let navigationBarImageView = hairlineImageViewInNavigationBar(self)
		navigationBarImageView!.isHidden = false
	}

	fileprivate func hairlineImageViewInNavigationBar(_ view: UIView) -> UIImageView? {
		if let view = view as?UIImageView , view.bounds.height <= 1.0 {
			return view
		}

		let subviews = (view.subviews as [UIView])
		for subview: UIView in subviews {
			if let imageView = hairlineImageViewInNavigationBar(subview) {
				return imageView
			}
		}

		return nil
	}

}
