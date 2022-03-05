//
//  Style.swift
//  aji
//
//  Created by aco on 22/10/2020.
//  Copyright © 2020 aco. All rights reserved.
// xcrun simctl status_bar "iPad Pro" override --time "9:41"     --batteryState charged --batteryLevel 10

import Foundation
import UIKit

public enum DefaultStyle {
	
	internal static func calculateColor(light: Int, dark: Int) -> UIColor {
		if #available(iOS 13, *) {
			return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
				if UITraitCollection.userInterfaceStyle == .dark {
					return UIColor(rgb: dark)
				}
				
				return UIColor(rgb: light)
			}
		}
		
		return UIColor(rgb: light)
	}
	
	public enum Colors {
		
		public static let primaryGreen = UIColor(rgb: 0x65B974)
		public static let tomato = UIColor(rgb: 0xFF6347)
		
		public static var mainBackground: UIColor = {
			return calculateColor(light: 0xffffff, dark: 0x000000)
		}()
		
		public static var bulletinBackground: UIColor = {
			return calculateColor(light: 0xffffff, dark: 0x191A1C)
		}()
		
		public static var altBackground: UIColor = {
			return calculateColor(light: 0xEBEBEB, dark: 0x2C2C2E)
		}()
		
		public static var altBackgroundInverted: UIColor = {
			return calculateColor(light: 0x2C2C2E, dark: 0xEBEBEB)
		}()
		
		public static var navigationElements: UIColor = {
			return calculateColor(light: 0x374857, dark: 0xe2e2e2)
		}()
		
		public static var border: UIColor = {
			return calculateColor(light: 0xffffff, dark: 0x1f1f1f)
		}()
		
		public static var primaryText: UIColor = {
			return .label // calculateColor(light: 0x273642, dark: 0xffffff)
		}()
		
		public static var secondaryText: UIColor = {
			return .secondaryLabel // return calculateColor(light: 0x858F96, dark: 0xa1a8ad)
		}()
		
		public static var tertiaryText: UIColor = {
			return .tertiaryLabel // calculateColor(light: 0x858F96, dark: 0xa1a8ad)
		}()
		
		public static var link: UIColor = {
			return calculateColor(light: 0x000000, dark: 0xffffff)
		}()
		
		public static var linkInverted: UIColor = {
			return calculateColor(light: 0xffffff, dark: 0x000000)
		}()
	}
}

public let Style = DefaultStyle.self

