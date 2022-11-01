//
//  MainView.swift
//  BarCodeBinaryScreenSaver
//
//  Created by Victor Apeland on 14/08/2019.
//  Copyright © 2019 Victor Apeland. All rights reserved.
//

import AppKit
import ScreenSaver
import Cocoa

// MARK: - SaverView
final class SaverView: ScreenSaverView {
	
	var digitCount: Int
	var mirror: Bool
	
	let dateFormatter: DateFormatter
	
	lazy var sheetController = ConfigureSheetController()
	
	let defaults: UserDefaults?
	
	var digitColorViews: [DigitColorView] = []
	
	var pImage: NSImage?
	var nImage: NSImage?
	
	// MARK: Initialization
	override init?(frame: NSRect, isPreview: Bool) {
//		defaults = ScreenSaverDefaults.init(forModuleWithName: Bundle(for: SaverView.self).bundleIdentifier!)
		defaults = UserDefaults.standard
		dateFormatter = DateFormatter()
		dateFormatter.dateFormat = defaults?.string(forKey: "dateFormat") ?? ""
		mirror = defaults?.bool(forKey: "mirror") ?? true
		digitCount = mirror ? 64 : 32
		super.init(frame: frame, isPreview: isPreview)
		
		
//		initColorViews()
//		let date = Date()
//		let calendar = Calendar.current
//		let comp = {(_ component: Calendar.Component) in return calendar.component(component, from: date)}
//		let msToFullSecond = 1000000000 - calendar.component(.nanosecond, from: date)
//		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//
//		}
		animationTimeInterval = TimeInterval(1)
		
		let pImagePath = defaults?.url(forKey: "pImagePath") ?? defaultPImagePath
		let nImagePath = defaults?.url(forKey: "nImagePath") ?? defaultNImagePath
		
		pImage = NSImage(contentsOf: pImagePath)
		nImage = NSImage(contentsOf: nImagePath)
		
		
		let characters = Array(leadingText) + [Character](repeating: " ", count: digitCount - leadingText.count)
		let width = frame.width / CGFloat(digitCount)
		for i in 0..<digitCount {
			let digitColorView = DigitColorView(index: i, representation: false, width: width, character: characters[i], superSize: frame.size)
			digitColorViews.append(digitColorView)
			addSubview(digitColorView)
			digitColorView.pView.image = pImage
			digitColorView.nView.image = nImage
		}
		animateOneFrame()
	}
	
	required init?(coder decoder: NSCoder) {
		defaults = UserDefaults.standard
		dateFormatter = DateFormatter()
		digitCount = 64
		mirror = defaults?.bool(forKey: "mirror") ?? true
		super.init(coder: decoder)
	}
	
	override var hasConfigureSheet: Bool { return true }
	override var configureSheet: NSWindow? { return sheetController.window }
	
	override func animateOneFrame() {
		super.animateOneFrame()
		let date = Date()
		let currentTime = Int(date.timeIntervalSince1970)
		
		for j in 0..<digitCount {
			let i = digitCount - 1 - j
			digitColorViews[j].representation = (currentTime & (1 << i)) != 0

			if mirror { digitColorViews[i].representation = digitColorViews[j].representation }
		}
		
		// Show date and time in corner
		let trailingText: [Character] = Array(dateFormatter.string(from: date))
		for i in 0..<trailingText.count {
			digitColorViews[digitCount - 1 - i].character = trailingText[trailingText.count - 1 - i]
		}
	}
}
