//
//  BundleInfo.swift
//  weather
//
//  Created by 이재문 on 2022/11/19.
//
import Foundation

enum BundleInfo {
    static let appID = Bundle.main.infoDictionary?["AppID"] as? String ?? ""
}
