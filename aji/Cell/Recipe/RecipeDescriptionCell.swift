//
//  RecipeDescriptionCell.swift
//  aji
//
//  Created by aco on 29/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class RecipeDescriptionCell: BaseRecipePresentableCell {
	
	public static let reuseIdentifier: String = "description-component-cell-reuse-ident"
	
	internal let descriptionLabel = Factory.generateBodyTextView()
	
	override var isHighlighted: Bool {
		didSet {
			Animator.applyTouchableAnimation(view: self.descriptionLabel, touchDown: self.isHighlighted)
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.addSubview(descriptionLabel)
		
		NSLayoutConstraint.activate([
			descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
			descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
			descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding),
			descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.padding)
		])
	}
	
	override func process(recipe: Recipe, indexPath: IndexPath) {
		self.descriptionLabel.text = recipe.description
		
		self.descriptionLabel.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 1.4)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
