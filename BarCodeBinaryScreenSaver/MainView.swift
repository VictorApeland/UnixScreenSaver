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
	
	var pImage: NSImage = NSImage.init(size: CGSize.zero) { didSet {
		for digitView in digitColorViews {
			digitView.pView.image = pImage
		}
	}}
	var nImage: NSImage = NSImage.init(size: CGSize.zero) { didSet {
		for digitView in digitColorViews {
			digitView.nView.image = nImage
		}
	}}
	
	// MARK: Initialization
	override init?(frame: NSRect, isPreview: Bool) {
		
//		defaults = ScreenSaverDefaults.init(forModuleWithName: "com.VictorApeland.BarCodeBinary")
		defaults = UserDefaults.standard
		dateFormatter = DateFormatter()
		dateFormatter.dateFormat = defaults?.string(forKey: "dateFormat") ?? ""
		mirror = defaults?.bool(forKey: "mirror") ?? true
		digitCount = mirror ? 64 : 32
		
		super.init(frame: frame, isPreview: isPreview)
		
		animationTimeInterval = TimeInterval(1)
		
		initColorViews()
		
		let url = URL(fileURLWithPath: "/Users/victorapeland/Pictures/SSImages/", isDirectory: true, relativeTo: nil)
		
		URLSession.shared.dataTask(with: URL(fileURLWithPath: "p.jpg", relativeTo: url), completionHandler: { data, response, error in
			guard let data = data, error == nil else { return }
			DispatchQueue.main.async() { [weak self] in
				self?.pImage = NSImage(data: data)!
			}
		}).resume()
		
		URLSession.shared.dataTask(with: URL(fileURLWithPath: "n.jpg", relativeTo: url), completionHandler: { data, response, error in
			guard let data = data, error == nil else { return }
			DispatchQueue.main.async() { [weak self] in
				self?.nImage = NSImage(data: data)!
			}
		}).resume()
	}
	
	func initColorViews() {
//		leadingText = String(describing: defaults?.bool(forKey: "ShowMinute"))
		let characters = Array(leadingText) + [Character](repeating: " ", count: digitCount - leadingText.count)
		let width = frame.width / CGFloat(digitCount)
		for i in 0..<digitCount {
			let digitColorView = DigitColorView(index: i, representation: false, width: width, character: characters[i], superSize: frame.size)
			digitColorViews.append(digitColorView)
			addSubview(digitColorView)
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
	
	override var hasConfigureSheet: Bool {
		return true
	}
	
	override var configureSheet: NSWindow? {
		return sheetController.window
	}
	
	override func animateOneFrame() {
		super.animateOneFrame()
		let date = Date()
		let currentTime = Int(date.timeIntervalSince1970)
		//Age: Int(Date().timeIntervalSince(Date(timeIntervalSinceReferenceDate: 60*60*24*365 + 60*60*24*334.5)))
//		guard digitColorViews.count == digitCount else {
//			// Account for potentially changing digitCount while running
//			initColorViews()
//			return
//		}
		for j in 0..<digitCount {
			let i = digitCount - 1 - j
			let digitColorView = digitColorViews[j]
			
			digitColorView.representation = (currentTime & (1 << i)) != 0
			
			// Mirror
			if mirror { digitColorViews[i].representation = digitColorView.representation}
		}
		
		// Show date and time in corner
		let trailingText: [Character] = Array(dateFormatter.string(from: date))
		
		for i in 0..<trailingText.count {
			digitColorViews[digitCount - 1 - i].character = trailingText[trailingText.count - 1 - i]
		}
	}
}
