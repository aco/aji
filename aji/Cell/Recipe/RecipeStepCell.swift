//
//  RecipeInstructionCell.swift
//  aji
//
//  Created by aco on 23/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class RecipeStepCell: BaseRecipePresentableCell {
	
	public static let reuseIdentifier = "RecipeStepCellReuseIdent"
	
	internal let badgeSize: CGFloat = Constant.trueScreenWidth * (Constant.isiPad ? 0.033 : 0.066)
	
	internal let label: UILabel = Factory.generateBodyTextView()
	
	internal lazy var badge: UILabel = Factory.buildAdditionalSourcesLabel(height: self.badgeSize, backgroundColor: Style.Colors.primaryGreen)
	
	override var isHighlighted: Bool {
		didSet {
			Animator.applyTouchableAnimation(view: self.label, touchDown: self.isHighlighted)
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)

		label.textColor = Style.Colors.primaryText
		
		contentView.addSubview(badge)
		contentView.addSubview(label)
		
		let offset = badge.font.capHeight / 2.0
		
		NSLayoutConstraint.activate([
			badge.topAnchor.constraint(equalTo: contentView.topAnchor),
			badge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
			badge.widthAnchor.constraint(equalToConstant: self.badgeSize),
			badge.heightAnchor.constraint(equalToConstant: self.badgeSize),
			badge.centerYAnchor.constraint(equalTo: label.firstBaselineAnchor, constant: -offset),
			
			label.leadingAnchor.constraint(equalTo: badge.trailingAnchor, constant: Constant.padding),
			label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding),
			label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	
	override func process(recipe: Recipe, indexPath: IndexPath) {
		self.label.text = recipe.instructions[indexPath.row]
		self.badge.text = "\(indexPath.row + 1)"
		
		label.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 1.4)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
