//
//  WinPageControl.swift
//  FBSnapshotTestCase
//
//  Created by Ahmad Almasri on 8/19/19.
//

import Foundation
import UIKit

 class WinPageControl: UIControl {
	private var limit: Int
	private var fullScaleIndex = [0, 1, 2]
	private var dotLayers: [CALayer] = []
	private var diameter: CGFloat { return radius * 2 }
	private var centerIndex: Int { return fullScaleIndex[1] }
	
	open var currentPage = 0 {
		didSet {
			guard numberOfPages > currentPage else {
				return
			}
			update()
		}
	}
	
	private var inactiveTintColor: UIColor {
		didSet {
			setNeedsLayout()
		}
	}
	
	private var currentPageTintColor: UIColor {
		didSet {
			setNeedsLayout()
		}
	}
	
	private var radius: CGFloat  {
		didSet {
			updateDotLayersLayout()
		}
	}
	
	private var padding: CGFloat  {
		didSet {
			updateDotLayersLayout()
		}
	}
	
	private var minScaleValue: CGFloat {
		didSet {
			setNeedsLayout()
		}
	}
	
	private var middleScaleValue: CGFloat {
		didSet {
			setNeedsLayout()
		}
	}
	
	private var numberOfPages: Int = 0 {
		didSet {
			setupDotLayers()
			isHidden = hideForSinglePage && numberOfPages <= 1
		}
	}
	
	private var hideForSinglePage: Bool = true
	
	private var inactiveTransparency: CGFloat {
		didSet {
			setNeedsLayout()
		}
	}
	
	private var borderWidth: CGFloat {
		didSet {
			setNeedsLayout()
		}
	}
	
	private var borderColor: UIColor {
		didSet {
			setNeedsLayout()
		}
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	required public init(frame: CGRect, numberOfPages: Int,
						 config: WinPageControlConfig) {
		self.limit = config.maxDots
		self.inactiveTintColor = config.inactiveTintColor
		self.currentPageTintColor = config.currentPageTintColor
		self.radius = config.radius
		self.padding = config.padding
		self.minScaleValue = config.minScaleValue
		self.middleScaleValue = config.middleScaleValue
		self.inactiveTransparency = config.inactiveTransparency
		self.borderColor = config.borderColor
		self.borderWidth = config.borderWidth
		super.init(frame: frame)
		self.numberOfPages = numberOfPages
		
		
		setupDotLayers()
	}
	

	override open var intrinsicContentSize: CGSize {
		return sizeThatFits(CGSize.zero)
	}
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		let minValue = min(7, numberOfPages)
		return CGSize(width: CGFloat(minValue) * diameter + CGFloat(minValue - 1) * padding, height: diameter)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		dotLayers.forEach {
			if borderWidth > 0 {
				$0.borderWidth = borderWidth
				$0.borderColor = borderColor.cgColor
			}
		}
		
		update()
	}
}

private extension WinPageControl {
	
	func setupDotLayers() {
		dotLayers.forEach{ $0.removeFromSuperlayer() }
		dotLayers.removeAll()
		
		(0..<numberOfPages).forEach { _ in
			let dotLayer = CALayer()
			layer.addSublayer(dotLayer)
			dotLayers.append(dotLayer)
		}
		
		updateDotLayersLayout()
		setNeedsLayout()
		invalidateIntrinsicContentSize()
	}
	
	func updateDotLayersLayout() {
		let floatCount = CGFloat(numberOfPages)
		let x = (bounds.size.width - diameter * floatCount - padding * (floatCount - 1)) * 0.5
		let y = (bounds.size.height - diameter) * 0.5
		var frame = CGRect(x: x, y: y, width: diameter, height: diameter)
		
		dotLayers.forEach {
			$0.cornerRadius = radius
			$0.frame = frame
			frame.origin.x += diameter + padding
		}
	}
	
	func setupDotLayersPosition() {
		let centerLayer = dotLayers[centerIndex]
		centerLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
		
		dotLayers.enumerated().filter{ $0.offset != centerIndex }.forEach {
			let index = abs($0.offset - centerIndex)
			let interval = $0.offset > centerIndex ? diameter + padding : -(diameter + padding)
			$0.element.position = CGPoint(x: centerLayer.position.x + interval * CGFloat(index), y: $0.element.position.y)
		}
	}
	
	func setupDotLayersScale() {
		dotLayers.enumerated().forEach {
			guard let first = fullScaleIndex.first, let last = fullScaleIndex.last else {
				return
			}
			
			var transform = CGAffineTransform.identity
			if !fullScaleIndex.contains($0.offset) {
				var scaleValue: CGFloat = 0
				if abs($0.offset - first) == 1 || abs($0.offset - last) == 1 {
					scaleValue = min(middleScaleValue, 1)
				} else if abs($0.offset - first) == 2 || abs($0.offset - last) == 2 {
					scaleValue = min(minScaleValue, 1)
				} else {
					scaleValue = 0
				}
				transform = transform.scaledBy(x: scaleValue, y: scaleValue)
			}
			
			$0.element.setAffineTransform(transform)
		}
	}
	
	func update() {
		dotLayers.enumerated().forEach() {
			$0.element.backgroundColor = $0.offset == currentPage ? currentPageTintColor.cgColor : inactiveTintColor.withAlphaComponent(inactiveTransparency).cgColor
		}
		
		guard numberOfPages > limit else {
			return
		}
		
		changeFullScaleIndexsIfNeeded()
		setupDotLayersPosition()
		setupDotLayersScale()
	}
	
	func changeFullScaleIndexsIfNeeded() {
		guard !fullScaleIndex.contains(currentPage) else {
			return
		}
		
		let moreThanBefore = (fullScaleIndex.last ?? 0) < currentPage
		if moreThanBefore {
			fullScaleIndex[0] = currentPage - 2
			fullScaleIndex[1] = currentPage - 1
			fullScaleIndex[2] = currentPage
		} else {
			fullScaleIndex[0] = currentPage
			fullScaleIndex[1] = currentPage + 1
			fullScaleIndex[2] = currentPage + 2
		}
	}
}
