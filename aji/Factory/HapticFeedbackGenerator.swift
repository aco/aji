//
//  HapticFeedbackGenerator.swift
//  aji
//
//  Created by aco on 28/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

/**
 * A 3D Touch selection feedback generator wrapper that uses the API only when available.
 */

class SelectionFeedbackGenerator {

		private let anyObject: AnyObject?

		init() {

				if #available(iOS 10, *) {
						anyObject = UISelectionFeedbackGenerator()
				} else {
						anyObject = nil
				}

		}

		func prepare() {

				if #available(iOS 10, *) {
						(anyObject as! UISelectionFeedbackGenerator).prepare()
				}

		}

		func selectionChanged() {

				if #available(iOS 10, *) {
						(anyObject as! UISelectionFeedbackGenerator).selectionChanged()
				}

		}

}

/**
 * A 3D Touch success feedback generator wrapper that uses the API only when available.
 */

class SuccessFeedbackGenerator {

		private let anyObject: AnyObject?

		init() {

				if #available(iOS 10, *) {
						anyObject = UINotificationFeedbackGenerator()
				} else {
						anyObject = nil
				}

		}

		func prepare() {

				if #available(iOS 10, *) {
						(anyObject as! UINotificationFeedbackGenerator).prepare()
				}

		}

		func success() {

				if #available(iOS 10, *) {
						(anyObject as! UINotificationFeedbackGenerator).notificationOccurred(.success)
				}

		}

}
