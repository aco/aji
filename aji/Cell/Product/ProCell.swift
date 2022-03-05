//
//  ProCell.swift
//  aji
//
//  Created by aco on 16/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class ProductProCell: UICollectionViewCell {
	
	public static let reuseIdentifier = "cell-product-resuse-identifier"
	
	override var isHighlighted: Bool {
		didSet {
			var transform = CGAffineTransform.identity
			
			if isHighlighted {
				transform = transform.scaledBy(x: 0.96, y: 0.96)
			}

			let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: Animator.shared.springTimingFunction)
			
			animator.addAnimations {
				self.transform = transform
			}
			
			animator.startAnimation()
		}
	}
	
	private(set) var rounded: Bool = false
	
	internal let titleLabel = Factory.generateTitleTextLabel(numberOfLines: 3)
	internal let subtitleLabel = Factory.generateSubtitleTextLabel(numberOfLines: 0)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.titleLabel.textColor = .white
		self.subtitleLabel.textColor = .white
		
		self.applyGradient(with: [
			Style.Colors.primaryGreen.withAlphaComponent(0.9),
			UIColor(rgb: 0x71F17D)
		])
		
		contentView.addSubview(titleLabel)
		contentView.addSubview(subtitleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.padding),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding),
			
			subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constant.padding / 4),
			subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
			subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.padding),
		])
		
		titleLabel.text = "Cook further with aji Pro!"
		subtitleLabel.text = "Unlimited recipes, sorted into cookbooks, fully modifiable and first priority on requests!"
	}
	
	override func layoutSubviews() {
		if !self.rounded {
			self.roundCorners(corners: .allCorners, radius: Constant.padding)
			self.rounded = true
		}
		
		super.layoutSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
