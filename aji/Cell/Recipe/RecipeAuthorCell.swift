//
//  RecipeAuthorCell.swift
//  aji
//
//  Created by aco on 17/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class RecipeAuthorCell: BaseRecipePresentableCell {
	
	public static let reuseIdentifier: String = "author-component-cell-reuse-ident"
	
	internal let titleLabel = Factory.generateSubtitleTextLabel(numberOfLines: 1)
	internal var shouldInteract = false
	
	override var isHighlighted: Bool {
		didSet {
			guard self.shouldInteract else {
				return
			}
			
			Animator.applyTouchableAnimation(view: self.titleLabel, touchDown: self.isHighlighted)
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.padding / 2),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding),
			titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	
	override func process(recipe: Recipe, indexPath: IndexPath) {
		self.titleLabel.text = recipe.author
		self.shouldInteract = recipe.urlString != nil
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
