//
//  RoundedSectionBackgroundDecorationView.swift
//  aji
//
//  Created by aco on 27/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class RoundedSectionBackgroundDecorationView: UICollectionReusableView {
	
	static let elementKind: String = "RoundedSectionBackgroundDecorationViewElementKind"
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = Style.Colors.mainBackground
		self.roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radius: Constant.padding / 2)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radius: Constant.padding / 2)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
