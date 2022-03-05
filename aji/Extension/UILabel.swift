//
//  UILabel.swift
//  nea
//
//  Created by aco on 17/07/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
	
	// Pass value for any one of both parameters and see result
	func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
		
		guard let labelText = self.text else { return }
		
		let paragraphStyle = NSMutableParagraphStyle()
		
		paragraphStyle.lineSpacing = lineSpacing
		paragraphStyle.lineHeightMultiple = lineHeightMultiple
		
		let attributedString:NSMutableAttributedString
		if let labelattributedText = self.attributedText {
			attributedString = NSMutableAttributedString(attributedString: labelattributedText)
		} else {
			attributedString = NSMutableAttributedString(string: labelText)
		}
		
		// Line spacing attribute
		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
		
		self.attributedText = attributedString
	}
}
