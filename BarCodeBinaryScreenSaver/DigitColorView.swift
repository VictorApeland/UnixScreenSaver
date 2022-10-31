//
//  DigitColorView.swift
//  FancyBinaryUnixTime
//
//  Created by Victor Apeland on 14/08/2019.
//  Copyright © 2019 Victor Apeland. All rights reserved.
//

import AppKit

class DigitColorView: NSView {
	
	let index: Int
	
	var representation: Bool { didSet{
		layer?.backgroundColor = representation ? NSColor.white.cgColor : NSColor.clear.cgColor
		characterLabel.textColor = representation ? NSColor.black : NSColor.white
		
		pView.isHidden = !representation
		nView.isHidden = representation
	}}
	
	// Variable for the character the line shows
	var character: Character {didSet{
		characterLabel.stringValue = String(character)
	}}
	
	let characterLabel: NSTextField
	
	let pView: NSImageView
	let nView: NSImageView
	
	init(index: Int, representation: Bool, width: CGFloat, character: Character, superSize: CGSize) {
		
		self.index = index
		self.representation = representation
		
		characterLabel = NSTextField(labelWithString: String(character))
		self.character = character
		
		pView = NSImageView(frame: NSRect(origin: CGPoint(x: -CGFloat(index)*width, y: 0), size: superSize))
		nView = NSImageView(frame: NSRect(origin: CGPoint(x: -CGFloat(index)*width, y: 0), size: superSize))
		
		super.init(frame: NSRect(
			x: CGFloat(index) * width,
			y: 0,
			width: width,
			height: 4000
		))
		
		wantsLayer = true
		
		pView.imageScaling = .scaleAxesIndependently
		nView.imageScaling = .scaleAxesIndependently
		
		addSubview(pView)
		addSubview(nView)
		addSubview(characterLabel)
		
		characterLabel.backgroundColor = NSColor.clear
		characterLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 20)
		characterLabel.alignment = .center
//		characterLabel.font = NSFont.systemFont(ofSize: 15, weight: .bold)
		
	}
	
	required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
