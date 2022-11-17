//
//  DailyForecastModel.swift
//  weather
//
//  Created by 이재문 on 2022/11/18.
//
import Foundation

struct DailyForecastData: Codable {
    var city: CityData
    var list: [ForecastData]
}

struct CityData: Codable {
    var timezone: Int
}

struct ForecastData: Codable {
    var dt: Int
    var temp: Temperature
    var weather: [Weather]
}

struct Temperature: Codable {
    var max: Double
    var min: Double
    
    private func convert2Celsius(degree: Double) -> Double {
        return degree - 273.15
    }
    
    func maxDegree() -> Int {
        return Int(convert2Celsius(degree: max).rounded())
    }
    
    func minDegree() -> Int {
        return Int(convert2Celsius(degree: min).rounded())
    }
}

struct Weather: Codable {
    var description: String
    var icon: String
}


