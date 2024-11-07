//
//  String+Extensions.swift
//  ToDoUsingCoreDataDemo
//
//  Created by Shafiq  Ullah on 11/6/24.
//

import Foundation

extension String{
    var isEmptyOrWhitespace: Bool{
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
