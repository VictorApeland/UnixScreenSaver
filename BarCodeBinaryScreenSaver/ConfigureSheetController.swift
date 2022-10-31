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
	
	var digitCount = 32
	var dateFormat: String
	var mirror: Bool
	let defaults: UserDefaults?
	
	override init() {
//		defaults = ScreenSaverDefaults.init(forModuleWithName: "com.VictorApeland.BarCodeBinary")
		defaults = UserDefaults.standard

		dateFormat = defaults?.string(forKey: "dateFormat") ?? ""
		mirror = defaults?.bool(forKey: "mirror") ?? true
        super.init()
        let myBundle = Bundle(for: ConfigureSheetController.self)
        myBundle.loadNibNamed("ConfigureSheet", owner: self, topLevelObjects: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

		mirrorBox.state = mirror ? .on : .off
		dateFormatField.stringValue = dateFormat
        
    }

	@IBAction func saveAndCloseSheet(_ sender: AnyObject) {
		// Test that the date format is valid
		let testFormatter = DateFormatter()
		testFormatter.dateFormat = dateFormatField.stringValue
		guard testFormatter.dateFormat == "" || testFormatter.string(from: Date()) != "" else {
			dateFormatField.layer?.borderColor = NSColor.red.cgColor
			return
		}
		dateFormatField.layer?.borderColor = NSColor.black.cgColor
		dateFormat = dateFormatField.stringValue
		
		mirror =  mirrorBox.state == .on
		
		defaults?.set(mirror, forKey: "mirror")
		defaults?.set(dateFormat, forKey: "dateFormat")
		
		closeConfigureSheet()
	}
	
	@IBAction func cancelAndCloseSheet(_ sender: AnyObject) {
		// Close without saving
		// Set boxes back to what they are representing
		mirrorBox.state = mirror ? .on : .off
		dateFormatField.stringValue = dateFormat
		
		closeConfigureSheet()
	}
	
	func closeConfigureSheet() {
        // Remember to close anything else first
//        NSColorPanel.shared.close()

        // Now close the sheet (this works on older macOS versions too)
        window?.sheetParent?.endSheet(window!)
    }
}
