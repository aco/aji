//
//  RecipeTitleCell.swift
//  aji
//
//  Created by aco on 23/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class RecipeTitleCell: BaseRecipePresentableCell {
	
	public static let reuseIdentifier: String = "header-component-cell-reuse-ident"
	
	internal let titleLabel: UILabel = {
		let label = UILabel()
		
		label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
		label.textColor = Style.Colors.primaryText
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}()
	
	override var isHighlighted: Bool {
		didSet {
			Animator.applyTouchableAnimation(view: self.titleLabel, touchDown: self.isHighlighted)
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.padding * 2),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding),
			titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	
	override func process(recipe: Recipe, indexPath: IndexPath) {
		self.titleLabel.text = recipe.name
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
