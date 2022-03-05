//
//  TitleSupplementaryCell.swift
//  aji
//
//  Created by aco on 23/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class TitleSupplementaryView: UICollectionReusableView {
	
	internal static let reuseIdentifier = "TitleSupplementaryViewReuseIdent"
	
	internal let titleLabel = Factory.generateTitleTextLabel(numberOfLines: 1, fontSize: 18)
	internal let authorLabel = Factory.generateSubtitleTextLabel(numberOfLines: 1)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(titleLabel)
		addSubview(authorLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.padding),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
