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
	
	@IBOutlet var secondsBox: NSButton!
	@IBOutlet var minutesBox: NSButton!
	@IBOutlet var hoursBox: NSButton!
	@IBOutlet var dayBox: NSButton!
	@IBOutlet var weekBox: NSButton!
	@IBOutlet var monthBox: NSButton!
	@IBOutlet var yearBox: NSButton!
	@IBOutlet var mirrorBox: NSButton!
	
	var showYear: Bool
	var showMonth: Bool
	var showWeek: Bool
	var showDay: Bool
	var showHour: Bool
	var showMinute: Bool
	var showSecond: Bool
	var digitCount = 32
	var mirror: Bool
	let defaults: UserDefaults?
	
	override init() {
//		defaults = ScreenSaverDefaults.init(forModuleWithName: "com.VictorApeland.BarCodeBinary")
		defaults = UserDefaults.standard
		showYear = defaults?.bool(forKey: "showYear") ?? true
		showMonth = defaults?.bool(forKey: "showMonth") ?? true
		showDay = defaults?.bool(forKey: "showDay") ?? false
		showWeek = defaults?.bool(forKey: "showWeek") ?? false
		showHour = defaults?.bool(forKey: "showHour") ?? true
		showMinute = defaults?.bool(forKey: "showMinute") ?? true
		showSecond = defaults?.bool(forKey: "showSecond") ?? true
		mirror = defaults?.bool(forKey: "mirror") ?? true
        super.init()
        let myBundle = Bundle(for: ConfigureSheetController.self)
        myBundle.loadNibNamed("ConfigureSheet", owner: self, topLevelObjects: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
		secondsBox.state = showSecond ? .on : .off
		minutesBox.state = showMinute ? .on : .off
		hoursBox.state   = showHour   ? .on : .off
		dayBox.state     = showDay    ? .on : .off
		weekBox.state    = showWeek   ? .on : .off
		monthBox.state   = showMonth  ? .on : .off
		yearBox.state    = showYear   ? .on : .off
		mirrorBox.state  = mirror     ? .on : .off
        
    }

	@IBAction func saveAndCloseSheet(_ sender: AnyObject) {
		mirror     =  mirrorBox.state == .on
		showSecond = secondsBox.state == .on
		showMinute = minutesBox.state == .on
		showHour   =   hoursBox.state == .on
		showDay    =     dayBox.state == .on
		showWeek   =    weekBox.state == .on
		showMonth  =   monthBox.state == .on
		showYear   =    yearBox.state == .on
		
		defaults?.set(     mirror, forKey: "mirror")
		defaults?.set( showSecond, forKey: "showSecond")
		defaults?.set( showMinute, forKey: "showMinute")
		defaults?.set(   showHour, forKey: "showHour")
		defaults?.set(    showDay, forKey: "showDay")
		defaults?.set(   showWeek, forKey: "showWeek")
		defaults?.set(  showMonth, forKey: "showMonth")
		defaults?.set(   showYear, forKey: "showYear")
		
		closeConfigureSheet()
	}
	
	@IBAction func cancelAndCloseSheet(_ sender: AnyObject) {
		// Close without saving
		// Set boxes back to what they are representing
		secondsBox.state = showSecond ? .on : .off
		minutesBox.state = showMinute ? .on : .off
		hoursBox.state   = showHour   ? .on : .off
		dayBox.state     = showDay    ? .on : .off
		weekBox.state    = showWeek   ? .on : .off
		monthBox.state   = showMonth  ? .on : .off
		yearBox.state    = showYear   ? .on : .off
		mirrorBox.state  = mirror     ? .on : .off
		
		closeConfigureSheet()
	}
	
	func closeConfigureSheet() {
        // Remember to close anything else first
//        NSColorPanel.shared.close()

        // Now close the sheet (this works on older macOS versions too)
        window?.sheetParent?.endSheet(window!)
    }
}
