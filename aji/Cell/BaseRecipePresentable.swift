//
//  BaseRecipeCell.swift
//  aji
//
//  Created by aco on 23/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class BaseRecipePresentableCell: UICollectionViewCell {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	func process(recipe: Recipe, indexPath: IndexPath) {
		return
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
