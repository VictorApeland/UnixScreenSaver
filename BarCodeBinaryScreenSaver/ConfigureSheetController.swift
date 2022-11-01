//
//  ConfigureSheetController.swift
//  BarCodeBinaryScreenSaver
//
//  Created by Victor Apeland on 29/10/2022.
//  Copyright © 2022 Victor Apeland. All rights reserved.
//

import Cocoa
import ScreenSaver

class ConfigureSheetController : NSObject {
    
    @IBOutlet var window: NSWindow?
	
	@IBOutlet var dateFormatField: NSTextField!
	
	@IBOutlet var mirrorBox: NSButton!
	
	@IBOutlet var pImageView: NSImageView!
	@IBOutlet var nImageView: NSImageView!
	
	var digitCount = 32
	var dateFormat: String
	var mirror: Bool
	
	let panel: NSOpenPanel
	
	var pImagePath: URL
	var nImagePath: URL
	let defaults: UserDefaults?
	
	override init() {
		let bundle = Bundle(for: ConfigureSheetController.self)
//		defaults = ScreenSaverDefaults.init(forModuleWithName: bundle.bundleIdentifier!)
		defaults = UserDefaults.standard
		
		dateFormat = defaults?.string(forKey: "dateFormat") ?? ""
		mirror = defaults?.bool(forKey: "mirror") ?? true
		pImagePath = defaults?.url(forKey: "pImagePath") ?? defaultPImagePath
		nImagePath = defaults?.url(forKey: "nImagePath") ?? defaultNImagePath
		
		panel = NSOpenPanel(contentRect: NSRect(x: 0, y: 0, width: 300, height: 200), styleMask: .utilityWindow, backing: .buffered, defer: true)
		
		super.init()
		
		panel.allowedFileTypes = NSImage.imageTypes
        bundle.loadNibNamed("ConfigureSheet", owner: self, topLevelObjects: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

		mirrorBox.state = mirror ? .on : .off
		dateFormatField.stringValue = dateFormat
		pImageView.image = NSImage(contentsOf: pImagePath)
		nImageView.image = NSImage(contentsOf: nImagePath)
    }
	
	@IBAction func selectPImage(_ sender: Any) {
		panel.begin(completionHandler: {response in
			guard response == .OK else { return }
			self.pImagePath = self.panel.url!
			self.pImageView.image = NSImage(contentsOf: self.pImagePath)
		})
	}
	
	@IBAction func selectNImage(_ sender: Any) {
		panel.begin(completionHandler: {response in
			guard response == .OK else { return }
			self.nImagePath = self.panel.url!
			self.nImageView.image = NSImage(contentsOf: self.nImagePath)
		})
	}
	
	@IBAction func saveAndCloseSheet(_ sender: AnyObject) {
		// Test that the date format is valid
		let testFormatter = DateFormatter()
		testFormatter.dateFormat = dateFormatField.stringValue
		guard testFormatter.dateFormat == "" || testFormatter.string(from: Date()) != "" else { return }
		dateFormat = dateFormatField.stringValue
		
		mirror =  mirrorBox.state == .on
		
		defaults?.set(mirror, forKey: "mirror")
		defaults?.set(dateFormat, forKey: "dateFormat")
		defaults?.set(pImagePath, forKey: "pImagePath")
		defaults?.set(nImagePath, forKey: "nImagePath")
		
		window?.sheetParent?.endSheet(window!)
	}
	
	@IBAction func cancelAndCloseSheet(_ sender: AnyObject) {
		// Close without saving
		// Set boxes back to what they are representing
		mirrorBox.state = mirror ? .on : .off
		dateFormatField.stringValue = dateFormat
		pImagePath = defaults?.url(forKey: "pImagePath") ?? defaultPImagePath
		nImagePath = defaults?.url(forKey: "nImagePath") ?? defaultNImagePath
		
		pImageView.image = NSImage(contentsOf: pImagePath)
		nImageView.image = NSImage(contentsOf: nImagePath)
		
		window?.sheetParent?.endSheet(window!)
	}
}
