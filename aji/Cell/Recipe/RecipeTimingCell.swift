//
//  RecipeTimingCell.swift
//  aji
//
//  Created by aco on 27/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class RecipeTimingCell: BaseRecipePresentableCell {
	
	public static let reuseIdentifier: String = "timing-component-cell-reuse-ident"
	
	internal lazy var prepTimeIcon = Factory.generateIconLabel(icon: "scalemass", altIcon: "hand.raised", color: Style.Colors.primaryGreen)
	internal lazy var cookTimeIcon = Factory.generateIconLabel(icon: "flame", color: Style.Colors.primaryGreen)
	
	internal lazy var prepTimeLabel = Factory.generateSubtitleTextLabel(numberOfLines: 1)
	internal lazy var cookTimeLabel = Factory.generateSubtitleTextLabel(numberOfLines: 1)
	
	internal lazy var noTimingLabel = Factory.generateSubtitleTextLabel(numberOfLines: 1)
	
	internal lazy var timingAvailable = true
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	override var isHighlighted: Bool {
		didSet {
			if self.timingAvailable {
				Animator.applyTouchableAnimation(view: self.prepTimeLabel, touchDown: self.isHighlighted)
				Animator.applyTouchableAnimation(view: self.cookTimeLabel, touchDown: self.isHighlighted)
			} else {
				Animator.applyTouchableAnimation(view: self.noTimingLabel, touchDown: self.isHighlighted)
			}
		}
	}
	
	private func displayNoTimingLabel() {
		noTimingLabel.text = "Add recipe timing information"
		
		contentView.addSubview(noTimingLabel)
		
		NSLayoutConstraint.activate([
			noTimingLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
			noTimingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
			noTimingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding),
			noTimingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	
	override func process(recipe: Recipe, indexPath: IndexPath) {
		if recipe.cookTime < 1 && recipe.prepTime < 1 {
			displayNoTimingLabel()
			timingAvailable = false
		} else if recipe.prepTime > 0 {
			contentView.addSubview(prepTimeIcon)
			contentView.addSubview(prepTimeLabel)
			
			prepTimeIcon.tintColor = Style.Colors.primaryGreen
			prepTimeLabel.text = Helper.minutesToFormattedInterval(interval: recipe.prepTime * 60, style: .full)
			
			NSLayoutConstraint.activate([
				prepTimeIcon.topAnchor.constraint(equalTo: contentView.topAnchor),
				prepTimeIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
				prepTimeIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
				
				prepTimeLabel.leadingAnchor.constraint(equalTo: prepTimeIcon.trailingAnchor, constant: Constant.padding / 2),
				prepTimeLabel.centerYAnchor.constraint(equalTo: prepTimeIcon.centerYAnchor)
			])
		}
		
		if recipe.cookTime > 0 {
			let leadingViewAnchor = recipe.prepTime > 0 ? prepTimeLabel.trailingAnchor : contentView.leadingAnchor
			
			contentView.addSubview(cookTimeIcon)
			contentView.addSubview(cookTimeLabel)
			
			cookTimeIcon.tintColor = Style.Colors.primaryGreen
			cookTimeLabel.text = Helper.minutesToFormattedInterval(interval: recipe.cookTime * 60, style: .full)
			
			NSLayoutConstraint.activate([
				cookTimeIcon.topAnchor.constraint(equalTo: contentView.topAnchor),
				cookTimeIcon.leadingAnchor.constraint(equalTo: leadingViewAnchor, constant: Constant.padding),
				cookTimeIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
				
				cookTimeLabel.leadingAnchor.constraint(equalTo: cookTimeIcon.trailingAnchor, constant: Constant.padding / 2),
				cookTimeLabel.centerYAnchor.constraint(equalTo: cookTimeIcon.centerYAnchor)
			])
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
