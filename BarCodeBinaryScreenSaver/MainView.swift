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
	
	var showYear: Bool
	var showMonth: Bool
	var showWeek: Bool
	var showDay: Bool
	var showHour: Bool
	var showMinute: Bool
	var showSecond: Bool
	var digitCount = 32
	var mirror: Bool
	
	let defaults: ScreenSaverDefaults?
	
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
		
		defaults = ScreenSaverDefaults.init(forModuleWithName: "com.VictorApeland.BarCodeBinary")
		showYear = defaults?.bool(forKey: "ShowYear") ?? true
		showMonth = defaults?.bool(forKey: "ShowMonth") ?? true
		showDay = defaults?.bool(forKey: "ShowDay") ?? false
		showWeek = defaults?.bool(forKey: "ShowWeek") ?? false
		showHour = defaults?.bool(forKey: "ShowHour") ?? true
		showMinute = defaults?.bool(forKey: "ShowMinute") ?? true
		showSecond = defaults?.bool(forKey: "ShowSecond") ?? true
		mirror = defaults?.bool(forKey: "Mirror") ?? true
		
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
		defaults = ScreenSaverDefaults.init(forModuleWithName: "com.VictorApeland.BarCodeBinary")
		showYear = defaults?.bool(forKey: "ShowYear") ?? true
		showMonth = defaults?.bool(forKey: "ShowMonth") ?? true
		showDay = defaults?.bool(forKey: "ShowDay") ?? false
		showWeek = defaults?.bool(forKey: "ShowWeek") ?? false
		showHour = defaults?.bool(forKey: "ShowHour") ?? true
		showMinute = defaults?.bool(forKey: "ShowMinute") ?? true
		showSecond = defaults?.bool(forKey: "ShowSecond") ?? true
		mirror = defaults?.bool(forKey: "Mirror") ?? true
		super.init(coder: decoder)
	}
	
	override var hasConfigureSheet: Bool {
		return true
	}
	lazy var sheetController = ConfigureSheetController()
	override var configureSheet: NSWindow? {

		return sheetController.window
	}
	
	override func animateOneFrame() {
		super.animateOneFrame()
		let currentTime = Int(Date().timeIntervalSince1970)
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
		// Closures
		let chars = {(number: Int) in return Array(String(number))}
		let padTT = {(number: Int) in return ((number < 10 ? ["0"] : []) + chars(number))}
		
		let date = Date()
		let calendar = Calendar.current
		let comp = {(_ component: Calendar.Component) in return calendar.component(component, from: date)}
		var trailingText: [Character] = (showDay ? [" "] : []) + (showWeek ? [" "] : []) + (showHour ? [" "] : [])
		
		if showYear   { trailingText += chars(comp(.year))   + "."}
		if showMonth  { trailingText += chars(comp(.month))  + "."}
		if showDay    { trailingText += chars(comp(.day))    + "."}
		if showWeek   { trailingText += "(" + chars(comp(.weekOfYear)) + ")" + "."}
		if showHour   { trailingText += chars(comp(.hour))   + "."}
		if showMinute { trailingText += padTT(comp(.minute)) + "."}
		if showSecond { trailingText += padTT(comp(.second))}
//		trailingText += "." + chars(comp(.nanosecond))
//		trailingText += Array(String(configureSheet == nil))
		
		for i in 0..<trailingText.count {
			digitColorViews[digitCount - 1 - i].character = trailingText[trailingText.count - 1 - i]
		}
	}
}
