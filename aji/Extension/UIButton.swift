//
//  UIButton.swift
//  nea
//
//  Created by aco on 09/09/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class ExtendedUIButton: UIButton {
	
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return self.bounds.insetBy(dx: -Constant.trueScreenWidth, dy: 0).contains(point)
	}
}
