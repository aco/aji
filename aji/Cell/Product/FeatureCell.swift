//
//  Feature.swift
//  aji
//
//  Created by aco on 20/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class ProductFeatureCell: UICollectionViewCell {
	
	public static let reuseIdentifier = "cell-product-feature-resuse-identifier"
	
	internal let titleLabel = Factory.generateTitleTextLabel(numberOfLines: 1)
	internal let noteLabel = Factory.generateSubtitleTextLabel(numberOfLines: 4)
	
	internal lazy var imageView: UIImageView = {
		let imageView = UIImageView(image: nil)
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.addSubview(imageView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(noteLabel)
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.widthAnchor.constraint(equalToConstant: Constant.padding),
			
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
//			titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constant.padding / 2),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding),
			
			noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constant.padding / 4),
			noteLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			noteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
