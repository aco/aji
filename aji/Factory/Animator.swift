//
//  Animator.swift
//  nea
//
//  Created by ac on 18/01/2019.
//  Copyright © 2019 abstersi. All rights reserved.
//

import Foundation
import UIKit

class Animator {
	
	enum Direction {
		case up
		case down
		case left
		case right
	}
	
	let entranceSpringTimingFunction = UISpringTimingParameters(dampingRatio: 1.2, initialVelocity: CGVector(dx: 1.0, dy: 0.0))
	let springTimingFunction = UISpringTimingParameters(dampingRatio: 0.7, initialVelocity: CGVector(dx: 0.033, dy: 0.0))
	
	public let bounce: CAAnimation = {
		let keyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
		
		keyframeAnimation.values = [1.0, 0.85, 1.15, 1.05, 0.95, 1.0]
		keyframeAnimation.duration = 0.4
		keyframeAnimation.calculationMode = CAAnimationCalculationMode.cubic
		
		return keyframeAnimation
	}()
	
	public let animateUp: CATransition = {
		let animation = CATransition()
		animation.duration = 0.18
		animation.type = CATransitionType.push
		animation.subtype = CATransitionSubtype.fromTop
		animation.timingFunction = .init(name: .easeInEaseOut)
		return animation
	}()
	
	public let animateDown: CATransition = {
		let animation = CATransition()
		animation.duration = 0.22
		animation.type = CATransitionType.push
		animation.subtype = CATransitionSubtype.fromBottom
		animation.timingFunction = .init(name: .easeInEaseOut)
		return animation
	}()
	
	static let shared = Animator()
	
	private static func buildAdjustedFrame(from frame: CGRect, offset: CGFloat, direction: Direction) -> CGRect {
		var x: CGFloat = 0
		var y: CGFloat = 0
		
		switch direction {
			case .left:
				x = -offset
				break
			case .right:
				x = offset
				break
			case .up:
				y = offset
				break
			default:
				y = -offset
		}
		
		return CGRect(x: frame.origin.x + x, y: frame.origin.y + y,
									width: frame.width, height: frame.height)
	}
	
	public static func applyPositionAnimation(target: UIView, offset: CGFloat, direction: Direction) {
		let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: Animator.shared.springTimingFunction)
		let finalFrame = buildAdjustedFrame(from: target.frame, offset: offset, direction: direction)
		
		animator.addAnimations {
			target.frame = finalFrame
		}
		
		animator.startAnimation()
	}
	
	public static func applyEntranceAnimation(target: UIView, duration: Double = 1.6, offset: CGFloat, delay: Double, direction: Direction, fade: Bool) {
		let finalFrame = target.frame
		
		target.frame = buildAdjustedFrame(from: target.frame, offset: offset, direction: direction)
		
		if fade {
			target.alpha = 0
		}
		
		let animator = UIViewPropertyAnimator(duration: duration, timingParameters: Animator.shared.springTimingFunction)
		
		animator.addAnimations {
			target.frame = finalFrame
			target.alpha = 1
		}
		
		animator.startAnimation(afterDelay: delay)
	}
	
	public static func applySpringEntranceAnimation(target: UIView, offset: CGFloat, order: Double, direction: Direction, fade: Bool = true, completion: ((UIViewAnimatingPosition) -> ())? = nil) {
		let finalFrame = target.frame
		
		target.frame = buildAdjustedFrame(from: target.frame, offset: offset, direction: direction)
		
		if fade {
			target.alpha = 0
		}
		
		let animator = UIViewPropertyAnimator(duration: 1.8, timingParameters: Animator.shared.entranceSpringTimingFunction)
		
		animator.addAnimations {
			target.frame = finalFrame
			target.alpha = 1
		}
		
		if let completion = completion {
			animator.addCompletion(completion)
		}
		
		animator.startAnimation()
	}
	
	public static func applyTouchableAnimation(view: UIView, touchDown: Bool) {
		UIView.animate(withDuration: touchDown ? 0.05 : 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
			view.alpha = touchDown ? 0.2 : 1.0
		}, completion: nil)
	}
}
