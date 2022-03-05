//
//  UpgradeBulletin.swift
//  aji
//
//  Created by aco on 20/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

import SwiftNotificationCenter
import SwiftyStoreKit

@objc class UpgradeBulletin: FeedbackPageBLTNItem {
	
	struct ProductFeature: Hashable {
		
		public let title: String
		public let description: String
		public let systemImageName: String
	}
	
	internal var dataSource: UICollectionViewDiffableDataSource<String, AnyHashable>! = nil
	
	internal let features = [
		ProductFeature(title: "Unlimited recipe saves", description: "Keep as many recipes from the web as you can", systemImageName: "plus.circle"),
		ProductFeature(title: "Custom cookbooks", description: "Sort your recipes into cookbooks for faster access and inspiration", systemImageName: "book.circle"),
		//		ProductFeature(title: "Safe in iCloud", description: "Store your recipes safely in iCloud for safekeeping", systemImageName: "icloud.circle"),
		ProductFeature(title: "Fully modifiable", description: "Evolve your recipes with the ability to add ingredients and steps", systemImageName: "pencil.and.outline"),
		ProductFeature(title: "First priority", description: "Some sites have trouble with aji's requests, so we account for those ourseves. Get top priority on adding new sites", systemImageName: "envelope.circle")
	]
	
	init(description: String) {
		super.init(title: "aji Pro!")
		
		alternativeButtonTitle = "Restore"
		descriptionText = "\(description.trimmingCharacters(in: .whitespaces)) No commitments - cancel anyntime."
		
		if let price = Constant.proProduct?.price {
			let currencyFormatter = NumberFormatter()
			
			currencyFormatter.usesGroupingSeparator = true
			currencyFormatter.numberStyle = .currency
			currencyFormatter.locale = Locale.current
			
			if let priceString = currencyFormatter.string(from: price) {
				actionButtonTitle = "Get \(priceString)/yr"
			}
		}
	}
	
	internal lazy var collectionView: UICollectionView = Factory.generateCollectionView(for: nil, delegate: self, layout: self.makeLayout())
	
	override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
		let collectionWrapper = interfaceBuilder.wrapView(collectionView, width: nil, height: 350 as NSNumber, position: .pinnedToEdges)
		
		collectionView.register(ProductFeatureCell.self, forCellWithReuseIdentifier: ProductFeatureCell.reuseIdentifier)
		collectionView.dataSource = self
		collectionView.delegate = self
		
		collectionView.alwaysBounceVertical = false
		collectionView.showsVerticalScrollIndicator = false
		
		return [collectionWrapper]
	}
	
	override func makeFooterViews(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
		let sv = interfaceBuilder.makeGroupStack(spacing: Constant.padding, axis: .horizontal)
		
		sv.addArrangedSubview(generateButton(title: "Privacy policy", touchUpInsideAction: #selector(didTouchUpInsidePrivacyButton)))
		sv.addArrangedSubview(generateButton(title: "Terms of use", touchUpInsideAction: #selector(didTouchUpInsideTermsButton)))
		
		return [interfaceBuilder.wrapView(sv, width: nil, height: Constant.padding / 2 as NSNumber, position: .centered)]
	}
	
	override public func tearDown() {
		super.tearDown()
		
		collectionView.dataSource = nil
		collectionView.delegate = nil
	}
	
	internal func applyPurchase() {
		Constant.purchased = true
		
		UserDefaults.standard.setValue(true, forKey: "checkingIAP")
		
		self.manager?.push(item: BulletinFactory.makeNoticePage(title: "Success!", brief: "Welcome to aji Pro!", buttonTitle: "Thanks!", handler: { (item) in
			item.manager?.dismissBulletin(animated: true)
			
			Broadcaster.notify(UpdateRecipes.self) {
				for key in DataManager.sharedInstance.keys() {
					$0.updateFromDatabase(database: key)
				}
			}
		}))
	}
	
	override public func actionButtonTapped(sender: UIButton) {
		guard let product = Constant.proProduct else {
			return
		}
		
		self.manager?.displayActivityIndicator(color: Style.Colors.primaryGreen)
		
		SwiftyStoreKit.purchaseProduct(product.productIdentifier, quantity: 1, atomically: true) { result in
			self.manager?.hideActivityIndicator()
			
			switch result {
				case .success(_):
					Constant.purchased = true
					self.applyPurchase()
					
					break
				case .error(let error):
					self.manager?.push(item: BulletinFactory.makeNoticePage(title: "Purchase Unsuccessful", brief: error.localizedDescription, buttonTitle: "Retry", handler: { (item) in
						item.manager?.popItem()
					}))
					
					break
			}
		}
		
		super.actionButtonTapped(sender: sender)
	}
	
	override public func alternativeButtonTapped(sender: UIButton) {
		guard Constant.proProduct != nil else {
			return
		}
		
		SwiftyStoreKit.restorePurchases(atomically: true) { results in
			if results.restoreFailedPurchases.count > 0 {
				self.manager?.push(item: BulletinFactory.makeNoticePage(title: "Restore failed", brief: results.restoreFailedPurchases.first?.1 ?? "Unknown error", buttonTitle: "Retry", handler: { (item) in
					item.manager?.popItem()
				}))
			}
			else if results.restoredPurchases.count > 0 {
				Constant.purchased = true
				self.applyPurchase()
			}
		}
		
		super.alternativeButtonTapped(sender: sender)
	}
}

extension UpgradeBulletin: UICollectionViewDataSource, UICollectionViewDelegate {
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.features.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductFeatureCell.reuseIdentifier, for: indexPath) as? ProductFeatureCell else {
			return collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
		}
		
		let feature = self.features[indexPath.row]
		
		cell.titleLabel.text = feature.title
		cell.noteLabel.text = feature.description
		
		cell.imageView.image = UIImage(systemName: feature.systemImageName)?.tintedWithLinearGradientColors(colorsArr: [
			Style.Colors.primaryGreen.withAlphaComponent(0.9).cgColor,
			UIColor(rgb: 0x71F17D).cgColor
		])
		
		return cell
	}
}

extension UpgradeBulletin {
	
	@objc internal func didTouchUpInsidePrivacyButton() {
		if let url = URL(string: "https://neanews.co/aji/privacy.html") {
			UIApplication.shared.open(url)
		}
	}
	
	@objc internal func didTouchUpInsideTermsButton() {
		if let url = URL(string: "https://neanews.co/aji/terms.html") {
			UIApplication.shared.open(url)
		}
	}
}

extension UpgradeBulletin {
	
	internal func generateButton(title: String, touchUpInsideAction: Selector) -> UIButton {
		let button = UIButton(type: .system)
		
		button.tintColor = Style.Colors.link
		button.setTitle(title, for: .normal)
		button.addTarget(self, action: touchUpInsideAction, for: .touchUpInside)
		
		return button
	}
	
	internal func makeLayout() -> UICollectionViewLayout {
		let estimation: CGFloat = 50
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimation))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimation))
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
		let section = NSCollectionLayoutSection(group: group)
		
		section.interGroupSpacing = Constant.padding
		let layout = UICollectionViewCompositionalLayout(section: section)
		
		return layout
	}
}
