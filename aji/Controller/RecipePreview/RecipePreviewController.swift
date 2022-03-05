//
//  RecipePreviewController.swift
//  aji
//
//  Created by aco on 01/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class RecipePreviewController: RecipeController {
	
	override init(recipe: Recipe, image: UIImage?) {
		super.init(recipe: recipe, image: image)
		self.defaultMultiplier = 0.000005
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
