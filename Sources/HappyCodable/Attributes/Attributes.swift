//
//  Attributes.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/17.
//

import Foundation


// MARK: - GenericTypeCodable

protocol GenericTypeAttribute: CustomDebugStringConvertible, CustomStringConvertible {
	associatedtype T
	var wrappedValue: T { get }
}

extension GenericTypeAttribute {
	public var debugDescription: String {
		String(describing: wrappedValue)
	}
	
	public var description: String {
		String(describing: wrappedValue)
	}
}

// MARK: - Attributes
public struct Happy { }
