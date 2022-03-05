/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * Represents a spacing value.
 */

@objc public class BLTNSpacing: NSObject {
    public let rawValue: CGFloat

    init(rawValue: CGFloat) {
        self.rawValue = rawValue
    }

    /// The standard spacing. (value: 12)
    @objc public class var regular: BLTNSpacing {
			return BLTNSpacing(rawValue: Constant.padding / 2)
    }
}
