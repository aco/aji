//
//  LatestRecipeCell.swift
//  aji
//
//  Created by aco on 28/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

import PINRemoteImage

class LatestRecipeCell: BaseRecipePresentableCell {
	
	public static let reuseIdentifier = "latest-recipe-cell-ident"
	
	internal let titleLabel = Factory.generateTitleTextLabel(numberOfLines: 3)
	internal lazy var subtitleLabel = Factory.generateSubtitleTextLabel(numberOfLines: 2)
	
	internal lazy var cookTimeIcon = Factory.generateIconLabel(icon: "timer", color: Style.Colors.primaryText, size: 12)
	internal lazy var cookTimeLabel = Factory.generateSubtitleTextLabel(numberOfLines: 1)
	
	internal let imageView: UIImageView = Factory.generateRoundedImageView()
	
	internal var recipe: Recipe? = nil
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = Style.Colors.mainBackground
		
		contentView.addSubview(imageView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(subtitleLabel)
	}
	
	open func setImageHeightConstraints(heightConstant: CGFloat) {
		let offset = titleLabel.font.capHeight / 2.0
		
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.heightAnchor.constraint(equalToConstant: heightConstant),
			
			titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constant.padding),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding / 2),
			
			subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constant.padding / 3),
			subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
			subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
		
		if let recipe = recipe, recipe.cookTime > 0 || recipe.prepTime > 0 {
			cookTimeLabel.textAlignment = .right
			cookTimeLabel.text = Helper.minutesToFormattedInterval(interval: (recipe.cookTime + recipe.prepTime) * 60, style: .abbreviated)
			
			cookTimeIcon.setContentCompressionResistancePriority(.required, for: .horizontal)
			cookTimeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
			
			contentView.addSubview(cookTimeIcon)
			contentView.addSubview(cookTimeLabel)
			
			NSLayoutConstraint.activate([
				cookTimeLabel.leadingAnchor.constraint(equalTo: cookTimeIcon.trailingAnchor, constant: Constant.padding / 4),
				cookTimeLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -Constant.padding / 2),
				cookTimeLabel.centerYAnchor.constraint(equalTo: cookTimeIcon.centerYAnchor),
				cookTimeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
				
				cookTimeIcon.centerYAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor, constant: -offset),
				
				titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: cookTimeIcon.leadingAnchor, constant: -Constant.padding / 2),
			])
		} else {
			NSLayoutConstraint.activate([
				titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constant.padding / 4)
			])
		}
	}
	
	override func process(recipe: Recipe, indexPath: IndexPath) {
		self.recipe = recipe
		
		titleLabel.text = recipe.name
		subtitleLabel.text = recipe.author
		
		if let imageUrl = recipe.imageUrl, let url = URL(string: imageUrl) {
			imageView.pin_setImage(from: url, placeholderImage: nil) { (result) in
				return
			}
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		self.imageView.image = nil
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		imageView.layer.borderColor = Style.Colors.border.cgColor
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
