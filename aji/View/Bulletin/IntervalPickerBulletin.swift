//
//  IntervalPickerBulletin.swift
//  aji
//
//  Created by aco on 29/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class IntervalPickerBulletin: FeedbackPageBLTNItem {
	
	internal lazy var picker: UIDatePicker = {
		let picker = UIDatePicker(frame: .zero)
		
		picker.datePickerMode = .countDownTimer
		picker.preferredDatePickerStyle = .wheels
		
		return picker
	}()
	
	override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
		return [picker]
	}
}
