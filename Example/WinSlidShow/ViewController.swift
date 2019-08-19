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
		
		//slider.setImage(source: .local([#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "1")]))
	    setupRemoteSloder()
		setupLocalSloder()
	}
	
	private func setupRemoteSloder() {
		remoteSlider.setImage(source: .remote([ "https://picjumbo.com/wp-content/uploads/pienza-town-in-tuscany_free_stock_photos_picjumbo_DSC04564-2210x1473.jpg", "https://i0.wp.com/picjumbo.com/wp-content/uploads/tuscany-sunset.jpg"], placeholder: #imageLiteral(resourceName: "placeholder")))
		remoteSlider.pageControlconfig.borderWidth = 3
		remoteSlider.pageControlconfig.borderColor = .red
		remoteSlider.showPageControl = true
	}
	private func setupLocalSloder() {
		localSlider.setImage(source: .local([#imageLiteral(resourceName: "local"),#imageLiteral(resourceName: "local"),#imageLiteral(resourceName: "local")]))
		localSlider.showPageControl = true
	}
}


