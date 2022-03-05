//
//  UIView.swift
//  aji
//
//  Created by aco on 23/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	func applyGradient(with colours: [UIColor], locations: [NSNumber]? = nil) {
		let gradient = CAGradientLayer()
		gradient.frame = self.bounds
		gradient.colors = colours.map { $0.cgColor }
		gradient.locations = locations
		self.layer.insertSublayer(gradient, at: 0)
	}
	
	func applyGradient(with colours: [UIColor]) {
		let gradient = CAGradientLayer()
		
		gradient.frame = self.bounds
		gradient.colors = colours.map { $0.cgColor }
		
		self.layer.insertSublayer(gradient, at: 0)
	}
	
	func roundCorners(corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		
		mask.path = path.cgPath
		
		layer.mask = mask
	}
}
