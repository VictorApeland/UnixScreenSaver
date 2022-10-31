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
	let defaults: ScreenSaverDefaults?
	
	override init() {
		defaults = ScreenSaverDefaults.init(forModuleWithName: "com.VictorApeland.BarCodeBinary")
		showYear = defaults?.bool(forKey: "ShowYear") ?? true
		showMonth = defaults?.bool(forKey: "ShowMonth") ?? true
		showDay = defaults?.bool(forKey: "ShowDay") ?? false
		showWeek = defaults?.bool(forKey: "ShowWeek") ?? false
		showHour = defaults?.bool(forKey: "ShowHour") ?? true
		showMinute = defaults?.bool(forKey: "ShowMinute") ?? true
		showSecond = defaults?.bool(forKey: "ShowSecond") ?? true
		mirror = defaults?.bool(forKey: "Mirror") ?? true
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
		
		defaults?.set(     mirror, forKey: "Mirror")
		defaults?.set( showSecond, forKey: "ShowSecond")
		defaults?.set( showMinute, forKey: "ShowMinute")
		defaults?.set(   showHour, forKey: "ShowHour")
		defaults?.set(    showDay, forKey: "ShowDay")
		defaults?.set(   showWeek, forKey: "ShowWeek")
		defaults?.set(  showMonth, forKey: "ShowMonth")
		defaults?.set(   showYear, forKey: "ShowYear")
		
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
        
        // Remember, you are still in memory at this point until you get killed by parent.
        // If your parent is System Preferences, you will remain in memory as long as System
        // Preferences is open. Reopening the sheet will just wake you up.
        //
        // An unfortunate side effect of this is that if your user updates to a new version with
        // System Preferences open, they will see weird things (ui from old version running
        // new code, etc), so tell them not to do that!
    }
}
