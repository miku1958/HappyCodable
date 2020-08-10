//
//  AppDelegate.swift
//  HappyCodableDemo
//
//  Created by 庄黛淳华 on 2020/5/24.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Cocoa
import HappyCodable

// TODO:    修改缓存逻辑, 当没有产生变化时不去修改 HappyCodable.generated.swift 减少编译器的判断

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		
//		let json = #"{ "name1": "name1.value", "🍉": "🍉.value", "abc": "abc.value"}"#.data(using: .utf8)!
//		let result = try! JSONDecoder().decode(Person.self, from: json)
	}
}

