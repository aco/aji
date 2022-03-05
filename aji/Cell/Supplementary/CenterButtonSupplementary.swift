//
//  CenterButtonSupplementary.swift
//  aji
//
//  Created by aco on 22/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class CenterButtonSupplementary: UICollectionReusableView {
	
	internal static let reuseIdentifier = "CenterButtonSupplementaryReuseIdent"
	
	internal lazy var button: UIButton = {
		let button = UIButton(type: .system)
		
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.tintColor = Style.Colors.primaryGreen
		
		button.titleLabel?.textAlignment = .center
		button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
		
		button.setTitle("test", for: .normal)
		button.setImage(UIImage(systemName: "plus"), for: .normal)
		
		button.titleEdgeInsets = UIEdgeInsets(top: 0, left: Constant.padding / 4, bottom: 0, right: -Constant.padding / 4)
		
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(button)
		
		NSLayoutConstraint.activate([
			button.topAnchor.constraint(equalTo: topAnchor, constant: Constant.padding),
			button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.padding),
			button.leadingAnchor.constraint(equalTo: leadingAnchor),
			button.trailingAnchor.constraint(equalTo: trailingAnchor),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
