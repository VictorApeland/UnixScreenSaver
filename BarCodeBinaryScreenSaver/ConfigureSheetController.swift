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
		pImagePath = defaults?.url(forKey: "pImagePath") ?? URL(fileURLWithPath: "/System/Library/Desktop Pictures/Motion Purple.heic")
		nImagePath = defaults?.url(forKey: "nImagePath") ?? URL(fileURLWithPath: "/System/Library/Desktop Pictures/Motion Yellow.heic")
		
		panel = NSOpenPanel(contentRect: NSRect(x: 0, y: 0, width: 300, height: 200), styleMask: .utilityWindow, backing: .buffered, defer: true)
		
		super.init()
		
		URLSession.shared.dataTask(with: pImagePath, completionHandler: { data, _, error in
			guard let data = data, error == nil else { return }
			DispatchQueue.main.async() { [weak self] in
				self?.pImageView.image = NSImage(data: data)!
			}
		}).resume()
		
		URLSession.shared.dataTask(with: nImagePath, completionHandler: { data, _, error in
			guard let data = data, error == nil else { return }
			DispatchQueue.main.async() { [weak self] in
				self?.nImageView.image = NSImage(data: data)!
			}
		}).resume()
		
		panel.allowedFileTypes = NSImage.imageTypes
        bundle.loadNibNamed("ConfigureSheet", owner: self, topLevelObjects: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

		mirrorBox.state = mirror ? .on : .off
		dateFormatField.stringValue = dateFormat
        
    }
	
	@IBAction func selectPImage(_ sender: Any) {
		
		panel.begin(completionHandler: {response in
			if response == .OK {
				self.pImagePath = self.panel.url!
				URLSession.shared.dataTask(with: self.pImagePath, completionHandler: { data, _, error in
					guard let data = data, error == nil else { return }
					DispatchQueue.main.async() { [weak self] in
						self?.pImageView.image = NSImage(data: data)!
					}
				}).resume()
			}
		})
	}
	
	@IBAction func selectNImage(_ sender: Any) {
		panel.begin(completionHandler: {response in
			if response == .OK {
				self.nImagePath = self.panel.url!
				URLSession.shared.dataTask(with: self.nImagePath, completionHandler: { data, _, error in
					guard let data = data, error == nil else { return }
					DispatchQueue.main.async() { [weak self] in
						self?.nImageView.image = NSImage(data: data)!
					}
				}).resume()
			}
		})
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
		defaults?.set(pImagePath, forKey: "pImagePath")
		defaults?.set(nImagePath, forKey: "nImagePath")
		
		closeConfigureSheet()
	}
	
	@IBAction func cancelAndCloseSheet(_ sender: AnyObject) {
		// Close without saving
		// Set boxes back to what they are representing
		mirrorBox.state = mirror ? .on : .off
		dateFormatField.stringValue = dateFormat
		
		pImagePath = defaults?.url(forKey: "pImagePath") ?? defaultPImagePath
		nImagePath = defaults?.url(forKey: "nImagePath") ?? defaultNImagePath
		
		URLSession.shared.dataTask(with: pImagePath, completionHandler: { data, _, error in
			guard let data = data, error == nil else { return }
			DispatchQueue.main.async() { [weak self] in
				self?.pImageView.image = NSImage(data: data)!
			}
		}).resume()
		URLSession.shared.dataTask(with: nImagePath, completionHandler: { data, _, error in
			guard let data = data, error == nil else { return }
			DispatchQueue.main.async() { [weak self] in
				self?.nImageView.image = NSImage(data: data)!
			}
		}).resume()
		
		closeConfigureSheet()
	}
	
	func closeConfigureSheet() {
        // Remember to close anything else first
//        NSColorPanel.shared.close()

        // Now close the sheet (this works on older macOS versions too)
        window?.sheetParent?.endSheet(window!)
    }
}
