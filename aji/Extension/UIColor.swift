import UIKit

extension UIColor {
	
	var isDarkColor: Bool {
		return self.brightness < 0.50
	}
	
	var brightness: CGFloat {
		var r, g, b, a: CGFloat
		(r, g, b, a) = (0, 0, 0, 0)
		
		self.getRed(&r, green: &g, blue: &b, alpha: &a)
		
		r = adjust(r, 0.2126)
		g = adjust(g, 0.7152)
		b = adjust(b, 0.0722)
		
		return r + g + b
	}
	
	public var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
			var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0

			getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

			return (hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
	}

	public func withSaturationUpdated(to newValue: CGFloat) -> UIColor {
			var newHsba = hsba

			newHsba.saturation = newValue

			return UIColor(hue: newHsba.hue, saturation: newHsba.saturation, brightness: newHsba.brightness, alpha: newHsba.alpha)
	}
	
	static func contrastRatio(between color1: UIColor, and color2: UIColor) -> CGFloat {
		// https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-tests
		
		let luminance1 = color1.luminance()
		let luminance2 = color2.luminance()
		
		let luminanceDarker = min(luminance1, luminance2)
		let luminanceLighter = max(luminance1, luminance2)
		
		return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
	}
	
	func contrastRatio(with color: UIColor) -> CGFloat {
		return UIColor.contrastRatio(between: self, and: color)
	}
	
	func luminance() -> CGFloat {
		// https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-tests
		
		let ciColor = CIColor(color: self)
		
		func adjust(colorComponent: CGFloat) -> CGFloat {
			return (colorComponent < 0.03928) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
		}
		
		return 0.2126 * adjust(colorComponent: ciColor.red) + 0.7152 * adjust(colorComponent: ciColor.green) + 0.0722 * adjust(colorComponent: ciColor.blue)
	}
	
	private func adjust(_ x: CGFloat, _ m: CGFloat) -> CGFloat {
		var y = x / 255
		
		if x <= 0.03928 {
			y = x / 12.92
		} else {
			y = pow(((x + 0.055) / 1.055), 2.4)
		}
		
		return y * m
	}
	
	func inverse() -> UIColor {
		var r, g, b, a: CGFloat
		(r, g, b, a) = (0, 0, 0, 0)
		
		self.getRed(&r, green: &g, blue: &b, alpha: &a)
		
		return UIColor(red: 1.0-r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
	}
	
	func resolvedColorForTraitStyle(_ traitStyle: UIUserInterfaceStyle) -> UIColor {
		return resolvedColor(with: UITraitCollection(userInterfaceStyle: traitStyle))
	}
	
	convenience public init(r: CGFloat, g: CGFloat, b: CGFloat) {
		self.init(r: r, g: g, b: b, a: 1)
	}
	
	convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
		self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
	}
	
	convenience public init(rgb: Int) {
		self.init(
			r: CGFloat((rgb >> 16) & 0xFF),
			g: CGFloat((rgb >> 8) & 0xFF),
			b: CGFloat(rgb & 0xFF)
		)
	}
}
