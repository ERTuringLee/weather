//
//  ForecastViewModel.swift
//  weather
//
//  Created by 이재문 on 2022/11/19.
//
enum CityName: String, CaseIterable  {
    case Seoul, London, Chicago
}

struct CityForecastViewModel {
    var cityForecasts: [CityForeCastData] = []
}

extension CityForecastViewModel {
    var numberOfSections: Int {
        guard !cityForecasts.isEmpty else {
            return 0
        }

        return cityForecasts.count
    }
    
    func numberOfRowInSection(_ section: Int) -> Int {
        guard !cityForecasts.isEmpty else {
            return 0
        }

        return 6
    }
}
