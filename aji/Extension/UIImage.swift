//
//  UIImage.swift
//  aji
//
//  Created by aco on 21/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	
	func tintedWithLinearGradientColors(colorsArr: [CGColor]) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
		guard let context = UIGraphicsGetCurrentContext() else {
			return UIImage()
		}
		context.translateBy(x: 0, y: self.size.height)
		context.scaleBy(x: 1, y: -1)
		
		context.setBlendMode(.normal)
		let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
		
		// Create gradient
		let colors = colorsArr as CFArray
		let space = CGColorSpaceCreateDeviceRGB()
		let gradient = CGGradient(colorsSpace: space, colors: colors, locations: nil)
		
		// Apply gradient
		context.clip(to: rect, mask: self.cgImage!)
		context.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: self.size.height), options: .drawsAfterEndLocation)
		
		let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return gradientImage!
	}
	
	func addImagePadding(x: CGFloat, y: CGFloat) -> UIImage? {
		let width: CGFloat = size.width + x
		let height: CGFloat = size.height + y
		
		UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
		
		let origin: CGPoint = CGPoint(x: (width - size.width) / 2, y: (height - size.height) / 2)
		
		draw(at: origin)
		
		let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		return imageWithPadding
	}
}
