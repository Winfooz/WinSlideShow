////
//  ViewController.swift
//  WinSlidShow
//
//  Created by Ahmad Almasri on 08/08/2019.
//  Copyright (c) 2019 Ahmad Almasri. All rights reserved.
//

import UIKit
import WinSlidShow

class ViewController: UIViewController {
	
	@IBOutlet weak var remoteSlider: WinSlideShow!
	@IBOutlet weak var localSlider: WinSlideShow!

	override func viewDidLoad() {
		super.viewDidLoad()
	    setupRemoteSloder()
		setupLocalSloder()
	}
	
	private func setupRemoteSloder() {
		for i in 0...5 {
		remoteSlider.setImage(source: .remote([ "https://picjumbo.com/wp-content/uploads/pienza-town-in-tuscany_free_stock_photos_picjumbo_DSC04564-2210x1473.jpg",
			"https://i0.wp.com/picjumbo.com/wp-content/uploads/tuscany-sunset.jpg",
			"https://picjumbo.com/wp-content/uploads/traveling-to-manarola-cinque-terre-follow-me-to-free-photo-DSC04349-2210x1473.jpg",
			"https://i0.wp.com/picjumbo.com/wp-content/uploads/giau-pass-mountain-la-gusela-peak-dolomites-italy.jpg",
			"https://i2.wp.com/picjumbo.com/wp-content/uploads/sea-coastline-italy-free-photo-DSC04430.jpg",
			"https://i2.wp.com/picjumbo.com/wp-content/uploads/yummy-fresh-burger-with-french-fries_free_stock_photos_picjumbo_DSC03833.jpg",
			"https://i1.wp.com/picjumbo.com/wp-content/uploads/tasty-colorful-muffins_free_stock_photos_picjumbo_IMG_3511.jpg",
			"https://i0.wp.com/picjumbo.com/wp-content/uploads/20180825-DSC05894.jpg",
			"https://i0.wp.com/picjumbo.com/wp-content/uploads/20180825-DSC05894.jpg",
			"https://i2.wp.com/picjumbo.com/wp-content/uploads/bali-temple-of-lempuyang.jpg",
			"https://i1.wp.com/picjumbo.com/wp-content/uploads/young-happy-woman-enjoying-freedom-on-a-walk-free-photo-DSC01183.jpg"
			], placeholder: #imageLiteral(resourceName: "placeholder")))
		remoteSlider.pageControlconfig.borderWidth = 1
		remoteSlider.pageControlconfig.borderColor = .orange
		remoteSlider.pageControlconfig.currentPageTintColor = .orange
		remoteSlider.pageControlconfig.inactiveTintColor = .white
		remoteSlider.pageControlconfig.radius = 7
		remoteSlider.showPageControl = true
		}
	}
	private func setupLocalSloder() {
		localSlider.setImage(source: .local([#imageLiteral(resourceName: "local"),#imageLiteral(resourceName: "local"),#imageLiteral(resourceName: "local"),#imageLiteral(resourceName: "local"),#imageLiteral(resourceName: "local"),#imageLiteral(resourceName: "local"),#imageLiteral(resourceName: "local"),#imageLiteral(resourceName: "local"),#imageLiteral(resourceName: "local"),#imageLiteral(resourceName: "local"),#imageLiteral(resourceName: "local")]))
		localSlider.pageControlconfig.borderWidth = 1
		localSlider.pageControlconfig.borderColor = .green
		localSlider.pageControlconfig.currentPageTintColor = .green
		localSlider.pageControlconfig.inactiveTintColor = .white
		localSlider.pageControlconfig.radius = 5
		localSlider.showPageControl = true
	}
}


