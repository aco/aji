/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

extension UIColor {

    var needsDarkText: Bool {
        return luminance() > sqrt(1.05 * 0.05) - 0.05
    }
}
