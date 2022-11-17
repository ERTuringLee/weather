//
//  CityForeCastData.swift
//  weather
//
//  Created by 이재문 on 2022/11/19.
//

struct CityForeCastData: Codable {
    var cityName: String
    var dailyForecastData: DailyForecastData
}
