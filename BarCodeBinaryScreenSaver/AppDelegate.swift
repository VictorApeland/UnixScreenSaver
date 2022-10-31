//
//  AppDelegate.swift
//  BarCodeBinaryScreenSaver
//
//  Created by Victor Apeland on 10/01/2021.
//  Copyright © 2021 Victor Apeland. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
//	private var controller: OptionsController?
	lazy var sheetController: ConfigureSheetController = ConfigureSheetController()

	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
//		screenSaverView.frame = (window.contentView?.bounds)!
//		window.contentView?.addSubview(screenSaverView)
		
		let objects = objectsFromNib(loadNibNamed: "ConfigureSheet")

		// We need to find the correct window in our nib
		let object = objects.first { object in
			if let window = object as? NSWindow, window.identifier?.rawValue == "MinimalSaver" {
				return true
			}
			return false
		}

		if let window = object as? NSWindow {
			setUp(preferencesWindow: window)
		}
		
	}
	
	private func objectsFromNib(loadNibNamed nibName: String) -> [AnyObject] {
		var topLevelObjects: NSArray? = NSArray()

		_ =  Bundle.main.loadNibNamed(nibName, owner: sheetController,
									  topLevelObjects: &topLevelObjects)

		return topLevelObjects! as [AnyObject]
	}
	
	private func setUp(preferencesWindow window: NSWindow) {
		window.makeKeyAndOrderFront(self)
		window.styleMask = [.closable, .titled, .miniaturizable]

		var frame = window.frame
		frame.origin = window.frame.origin
		window.setFrame(frame, display: true)
	}
	
}
