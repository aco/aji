//
//  Constant.swift
//  aji
//
//  Created by aco on 21/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation

import StoreKit
import UIKit

class Constant {
	
	static let shared: Constant = Constant()
	
	static let isiPad = UIDevice.current.userInterfaceIdiom == .pad
	
	static let padding: CGFloat = Constant.isiPad ? 35 : 25
	static let hairlineWidth: CGFloat = 0.5
	
	static let screenSize = UIScreen.main.bounds.size
	
	static let trueScreenWidth = min(screenSize.width, screenSize.height)
	static let trueScreenHeight = max(screenSize.width, screenSize.height)
	
	static var proProduct: SKProduct?
	static var purchased: Bool = false // IAPManager.shared.isProductPurchased(productId: Constant.proProduct?.productIdentifier ?? "")
	static var iapSecret = "8569c919f0224918a09af02d9ba6495d"
}
