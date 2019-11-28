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
	private var bannerView: UICollectionView!
	private var itemCount: Int = 0
	private var pageControl: WinPageControl?
	private var winRemoteDataSource = WinRemoteDataSource()
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
		let frame =  CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
		
		let layout =  UICollectionViewFlowLayout()
		layout.itemSize = self.frame.size
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing  = 0
		layout.minimumInteritemSpacing = 0
		
		bannerView = UICollectionView(frame: frame, collectionViewLayout: layout)
		bannerView.backgroundColor = .white
		bannerView.isPagingEnabled = true
		bannerView.register(RemoteCell.self, forCellWithReuseIdentifier: "\(RemoteCell.self)")
		self.addSubview(bannerView)
	}
	
	private func setupRemoteSliders(_ urls: [String], placeholder: UIImage?) {
		
		setupScrollView()
		winRemoteDataSource.items = urls
		winRemoteDataSource.placeholder = placeholder
		bannerView.delegate = winRemoteDataSource
		bannerView.dataSource = winRemoteDataSource
		winRemoteDataSource.delegate = self
		bannerView.reloadData()

		
	}
	
	private func setupLocalSliders(_ images: [UIImage]) {
		
		setupScrollView()
		winRemoteDataSource.images = images
		bannerView.delegate = winRemoteDataSource
		bannerView.dataSource = winRemoteDataSource
		winRemoteDataSource.delegate = self
		bannerView.reloadData()

	}
	
	private func setupPageControl() {
		pageControl?.removeFromSuperview()
		let height = pageControlconfig.radius * 5
		let frame = CGRect(x: 0, y: self.frame.height - (height), width: self.frame.width, height: height)
		 pageControl = WinPageControl(frame: frame, numberOfPages: self.itemCount, config: pageControlconfig)
		pageControl?.backgroundColor = pageControlconfig.pagerBackgroundColor
		if let pageControl = pageControl {
		self.addSubview(pageControl)
		}
	}
	
	public func scroll(to position: Int) {
		
		self.currentPage = position
		self.bannerView.scrollToItem(at: IndexPath(item: position, section: 0), at: .right, animated: false)
	}
}

extension WinSlideShow: WinRemoteDelegate {
	
	func didMoved(to: Int) {
		self.currentPage = to
		self.delegate?.didMoved(to: to)
	}
}

protocol WinRemoteDelegate: AnyObject {
	
	func didMoved(to: Int)
}

class WinRemoteDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	var items = [String]()
	weak var delegate: WinRemoteDelegate?
	var placeholder: UIImage?
	var images: [UIImage]?
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return images != nil ? images!.count : items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RemoteCell.self)", for: indexPath) as! RemoteCell
		
		if images != nil {
			cell.localConfig(images![indexPath.row])
		} else {
		cell.remoteConfig(items[indexPath.row], placeholder: placeholder)
		}
		return cell
	}
	
	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
		print(pageNumber)
		delegate?.didMoved(to: Int(pageNumber))
	}
}

class RemoteCell: UICollectionViewCell {
	
	var imageView: UIImageView!
	var placeholder: UIImage?
	
	open override func awakeFromNib() {
		super.awakeFromNib()
		
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		if imageView == nil {
			self.setupImageView()
		}
	}
	open func remoteConfig(_ url: String, placeholder: UIImage?) {
		if imageView == nil {
			self.setupImageView()
		}
		if let url = URL(string: url) {
			imageView.sd_setImage(with: url, placeholderImage: placeholder)
		}else {
			imageView.image = placeholder
		}
		
	}
	
	open func localConfig(_ image: UIImage) {
		if imageView == nil {
			self.setupImageView()
		}
		
		imageView.image = image
	}
	
	
	open override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}
	
	private func setupImageView() {
		
		imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		self.contentView.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
			imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
			imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
			imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
			])
	}
	
	func rotateView(with angle: Double) {
		
		UIView.animate(withDuration: 0.3) {
			self.contentView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))

		}
	}
}
