//
//  AppDelegate.swift
//  aji
//
//  Created by aco on 17/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import UIKit
import StoreKit

import SwiftNotificationCenter
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	func checkSubscription(productId: String) {
		guard UserDefaults.standard.bool(forKey: "checkingIAP") else {
			Broadcaster.notify(UpdateRecipes.self) {
				$0.iapChanged()
			}
			
			return
		}
		
		let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: Constant.iapSecret)
		SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
			switch result {
				case .success( _):
					SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
						switch result {
							case .success(let receipt):
								let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productId, inReceipt: receipt)
								
								print(purchaseResult)
								
								switch purchaseResult {
									case .purchased(let expiryDate, let items):
										print("\(productId) is valid until \(expiryDate)\n\(items)\n")
										Constant.purchased = true
										break
									default:
										Broadcaster.notify(UpdateRecipes.self) {
											$0.iapChanged()
										}
										
										break
								}
								
							case .error(let error):
								Broadcaster.notify(UpdateRecipes.self) {
									$0.iapChanged()
								}
								
								print("Receipt verification failed: \(error)")
						}
					}
				case .error(let error):
					print("Fetch receipt failed: \(error)")
			}
		}
	}
	
	internal func fetchPurchases() {
		guard let url = Bundle.main.url(forResource: "iap_prod_ids", withExtension: "plist") else {
			fatalError("Unable to resolve url for in the bundle.")
		}
		
		do {
			let data = try Data(contentsOf: url)
			
			guard let productIdentifiers = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String] else {
				return
			}
			
			SwiftyStoreKit.retrieveProductsInfo(Set(productIdentifiers)) { result in
				if let product = result.retrievedProducts.first {
					Constant.proProduct = product
					self.checkSubscription(productId: product.productIdentifier)
				} else if let invalidProductId = result.invalidProductIDs.first {
					print("Invalid product identifier: \(invalidProductId)")
				}
			}
		} catch let error as NSError {
			print("\(error.localizedDescription)")
		}
		
		SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
			for purchase in purchases {
				switch purchase.transaction.transactionState {
					case .purchased, .restored:
						if purchase.needsFinishTransaction {
							// Deliver content from server, then:
							SwiftyStoreKit.finishTransaction(purchase.transaction)
						}
					// Unlock content
					case .failed, .purchasing, .deferred:
						break // do nothing
					@unknown default:
						break
				}
			}
		}
	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		fetchPurchases()
		
		_ = DataManager.sharedInstance
		
		configureGlobalAppearances()
		
		UserDefaults.standard.register(defaults: [
			"checkingIAP": false
		])
		
		//		IAPManager.shared.checking = UserDefaults.standard.bool(forKey: "checkingIAP")
		
		return true
	}
	
	fileprivate func configureGlobalAppearances() {		
		UINavigationBar.appearance().shadowImage = UIImage()
		
		var style = ToastStyle()
		
		style.backgroundColor = Style.Colors.primaryGreen
		style.messageColor = .white
		style.fadeDuration = 0.4
		
		ToastManager.shared.style = style
	}
	
	// MARK: UISceneSession Lifecycle
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
	
	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
}
