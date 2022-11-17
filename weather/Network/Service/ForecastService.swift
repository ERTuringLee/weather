//
//  ForecastService.swift
//  weather
//
//  Created by 이재문 on 2022/11/18.
//

import Moya
import RxSwift

final class ForecastService: BaseService<ForecastAPI> {
    static let shared = ForecastService()
    private override init() {}
    
    func daily(cityName: String, _ completion: @escaping (DailyForecastData?, Error?) -> Void) {
        request(.daily(cityName: cityName))
            .filterSuccessfulStatusCodes()
            .map(DailyForecastData.self)
            .subscribe(
                onSuccess: {response in
                    completion(response, nil)
                },
                onFailure: {error in
                    completion(nil, error)
                }
            ).disposed(by: disposeBag)
    }
}
