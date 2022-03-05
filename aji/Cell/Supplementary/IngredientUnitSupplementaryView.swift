//
//  IngredientUnitSupplementaryHeader.swift
//  aji
//
//  Created by aco on 27/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class IngredientUnitSupplementaryView: UICollectionReusableView {
	
	static let reuseIdentifier = "title-supplementary-reuse-identifier"
	
	internal let titleLabel = Factory.generateTitleTextLabel(numberOfLines: 1, fontSize: 18)
	
	internal let actionButton: UIButton = {
		let label = ExtendedUIButton(type: .system)
		
		label.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
		label.tintColor = Style.Colors.secondaryText
		label.titleLabel?.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		label.setTitleColor(Style.Colors.secondaryText, for: .disabled)
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(titleLabel)
		addSubview(actionButton)
		
		titleLabel.text = "Ingredients"
//		titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.padding),
			
			actionButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
			actionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constant.padding),
			actionButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
		])
	}
	
	@objc internal func didTouchDownButton() {
		
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
}
