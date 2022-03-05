//
//  RecipeIngredientCell.swift
//  aji
//
//  Created by aco on 23/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class RecipeIngredientCell: BaseRecipePresentableCell {
	
	public static let reuseIdentifier = "RecipeIngredientCellReuseIdent"
	
	internal let titleLabel = Factory.generateBodyTextView()
	internal lazy var noteLabel = Factory.generateSubtitleTextLabel(numberOfLines: 2)
	
	override var isHighlighted: Bool {
		didSet {
			Animator.applyTouchableAnimation(view: self.contentView, touchDown: self.isHighlighted)
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.addSubview(titleLabel)
		contentView.addSubview(noteLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding),
			
			noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constant.padding / 3),
			noteLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			noteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	
	private func removeZerosFromEnd(double: Double) -> String {
		let (_, fractionalPart) = modf(double)
		if fractionalPart > 0 {
			let r = Rational(approximating: double)
			
			if r.numerator < r.denominator {
				return "\(r.numerator)/\(r.denominator)"
			}
		}
		
		let formatter = NumberFormatter()
		let number = NSNumber(value: double)
		
		formatter.minimumFractionDigits = 0
		formatter.maximumFractionDigits = 3 // maximum digits in Double after dot (maximum precision)
		formatter.numberStyle = .decimal
		
		return String(formatter.string(from: number) ?? "")
	}
	
	override func process(recipe: Recipe, indexPath: IndexPath) {
		let ingredient = recipe.ingredients[indexPath.row]
		
		var str = ""
		
		if let quantity = ingredient.quantity {
			if let quantityDouble = quantity as? Double {
				str.append("\(removeZerosFromEnd(double: quantityDouble))")
			} else if let quantityInt = quantity as? Int {
				str.append("\(quantityInt)")
			} else {
				str.append("\(quantity)")
			}
			
			if let unit = ingredient.unit {
				str.append(" \(unit)")
			}
			
			str.append(" \(ingredient.name)")
		} else {
			str = ingredient.name
		}
		
		self.titleLabel.text = str
		self.noteLabel.text = ingredient.preparationComment
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
