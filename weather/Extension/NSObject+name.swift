//
//  NSObject+name.swift
//  weather
//
//  Created by 이재문 on 2022/11/19.
//
import Foundation

extension NSObject {
    func name() -> String {
        return String(describing: type(of: self))
    }
}
