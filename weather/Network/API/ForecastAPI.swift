//
//  ForecastAPI.swift
//  weather
//
//  Created by 이재문 on 2022/11/18.
//

import Moya

enum ForecastAPI {
    case daily(cityName: String)
}

extension ForecastAPI: BaseAPI {
    var path: String {
        switch self {
        case .daily:
            return "/daily"
        }
    }
    
    var task: Task {
        switch self {
        case .daily(let cityName):
            return .requestParameters(parameters: ["q": cityName, "appid": BundleInfo.appID], encoding: URLEncoding.queryString)
        }
    }
}
