//
//  WinSlideShow.swift
//  FBSnapshotTestCase
//
//  Created by Ahmad Almasri on 8/8/19.
//

import Foundation
import UIKit
import SDWebImage

@objc public protocol ImageSliderDelegate {
	
	func didMoved(to index: Int)
}

open class WinSlideShow: UIView {
	
	// MARK:- enums
	public enum ImageSource {
		case remote(_ urls: [String], placeholder: UIImage?)
		case local(_ images: [UIImage])
	}
	
	public enum SlideMode {
		case manual
	//	case auto(_ interval: Double)
	}
	
	// MARK:- Vars
	public weak var delegate: ImageSliderDelegate?
	public let scrollView = UIScrollView()
	private var itemCount: Int = 0
	private var pageControl: WinPageControl?
	public var currentPage = 0 {
		willSet {
			pageControl?.currentPage = newValue
		}
	}
	
	public  var pageControlconfig = WinPageControlConfig() {
		willSet {
			print("new Config")
		}
	}
	public var showPageControl = false {
		
		willSet {
			if newValue {
				
				setupPageControl()
			}
		}
	}
	/**
	This function set up the image slider for you just pass few required parameters to it

	- parameter imageSource: to show images from url use -> .remote(_ urls: [String], placeholder: UIImage?) and provide url array and placeholder image in paranthesis, to show local images use -> .local(_ images: [UIImage]) and provide local image names array in paranthesis
	
	- parameter slideType: to  slide images automatically use -> .auto(_ interval: Double) and provide time interval(Seconds) in parantheseis, to swipe and slide images manually simply use -> .manual
	*/
	public func setImage(source imageSource: ImageSource) {
		
			switch imageSource {
				
			case .remote(let urls, let placeholder):
				self.itemCount = urls.count
				self.setupRemoteSliders(urls, placeholder: placeholder)
				
			case .local(let images):
				self.itemCount = images.count
				self.setupLocalSliders(images)
			}
		
	}
	
	private func setupScrollView() {
		self.setNeedsLayout()
		self.layoutIfNeeded()
		scrollView.removeFromSuperview()
		self.scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
		self.scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(self.itemCount), height: self.frame.height)
		self.scrollView.isPagingEnabled = true
		self.scrollView.delegate = self
		self.addSubview(scrollView)
	}
	
	private func setupRemoteSliders(_ urls: [String], placeholder: UIImage?) {
		
		setupScrollView()
		
		for i in 0 ..< urls.count {
			
			let imageView = UIImageView()
			imageView.frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: self.frame.height)
			if let url = URL(string: urls[i]) {
			imageView.sd_setImage(with: url, placeholderImage: placeholder)
			}else {
				imageView.image = placeholder
			}
			scrollView.addSubview(imageView)
		}
		
	}
	
	private func setupLocalSliders(_ images: [UIImage]) {
		
		setupScrollView()
		
		for i in 0 ..< images.count {
			
			let imageView = UIImageView()
			imageView.frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: self.frame.height)
			imageView.image = images[i]
			scrollView.addSubview(imageView)
		}
	}
	
	private func setupPageControl() {
		pageControl?.removeFromSuperview()
		let height = pageControlconfig.radius * 5
		let frame = CGRect(x: 0, y: self.frame.height - (height), width: self.frame.width, height: height)
		 pageControl = WinPageControl(frame: frame, numberOfPages: self.itemCount, config: pageControlconfig)
		pageControl?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		if let pageControl = pageControl {
		self.addSubview(pageControl)
		}
	}
}

extension WinSlideShow: UIScrollViewDelegate {
	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
		currentPage = Int(pageNumber)
		delegate?.didMoved(to: currentPage)
	}
}
