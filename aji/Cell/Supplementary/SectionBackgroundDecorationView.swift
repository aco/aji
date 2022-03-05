//
//  SectionBackgroundDecorationView.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/10/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

import UIKit

final class SectionBackgroundDecorationView: UICollectionReusableView {
	
	static let elementKind: String = "SectionBackgroundDecorationViewElementKind"
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = Style.Colors.mainBackground
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

