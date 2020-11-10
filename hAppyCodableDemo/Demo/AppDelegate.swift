//
//  AppDelegate.swift
//  Demo
//
//  Created by 庄黛淳华 on 2020/9/27.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Cocoa
import SwiftUI


func assert(_ condition: @autoclosure () throws -> Bool) {
	do {
		let result = try condition()
		Swift.assert(result)
	} catch {
		Swift.assertionFailure()
	}
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var window: NSWindow!


	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Create the SwiftUI view that provides the window contents.
		let contentView = ContentView()

		// Create the window and set the content view. 
		window = NSWindow(
		    contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
		    styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
		    backing: .buffered, defer: false)
		window.center()
		window.setFrameAutosaveName("Main Window")
		window.contentView = NSHostingView(rootView: contentView)
		window.makeKeyAndOrderFront(nil)
		
		try? test()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

func test() throws {
	let fakeData_Double = Double(Int.random(in: 0...10000))
	var json: NSDictionary = [
		"doubleConvertFromString": fakeData_Double,
		
		"doubleThrow": fakeData_Double
	]
	
	assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).toJSON() as NSDictionary == json)
	
	do {
		let object = try TestStruct_nonConformingFloatStrategy.decode(from: [:])
		assert(object.doubleThrow == TestStruct_nonConformingFloatStrategy.Data.fakeData_double)
		assert(object.doubleConvertFromString == TestStruct_nonConformingFloatStrategy.Data.fakeData_double)
	} catch {
		assertionFailure()
	}
	
	
	json = [
		"doubleThrow": TestStruct_nonConformingFloatStrategy.Data.nan
	]
	do {
		_ = try TestStruct_nonConformingFloatStrategy.decode(from: json)
		assertionFailure()
	} catch {}
	
	json = [
		"doubleConvertFromString": TestStruct_nonConformingFloatStrategy.Data.nan
	]
	// Double.nan 是不能对比的
	assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).doubleConvertFromString.isNaN)
	assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).toJSON() as NSDictionary == [
		"doubleConvertFromString": TestStruct_nonConformingFloatStrategy.Data.nan,
		"doubleThrow": TestStruct_nonConformingFloatStrategy.Data.fakeData_double
	])
	json = [
		"doubleConvertFromString": TestStruct_nonConformingFloatStrategy.Data.positiveInfinity
	]
	
	assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).doubleConvertFromString == .infinity)
	assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).toJSON() as NSDictionary == [
		"doubleConvertFromString": TestStruct_nonConformingFloatStrategy.Data.positiveInfinity,
		"doubleThrow": TestStruct_nonConformingFloatStrategy.Data.fakeData_double
	])
	
	json = [
		"doubleConvertFromString": TestStruct_nonConformingFloatStrategy.Data.negativeInfinity
	]
	assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).doubleConvertFromString == -.infinity)
	assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).toJSON() as NSDictionary == [
		"doubleConvertFromString": TestStruct_nonConformingFloatStrategy.Data.negativeInfinity,
		"doubleThrow": TestStruct_nonConformingFloatStrategy.Data.fakeData_double
	])
	
}
