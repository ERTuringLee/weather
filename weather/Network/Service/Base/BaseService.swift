//
//  BaseService.swift
//  weather
//
//  Created by 이재문 on 2022/11/18.
//

import Moya
import RxSwift

class BaseService<API: TargetType> {
    let disposeBag = DisposeBag()
    private let provider = MoyaProvider<API>()
    
    func request(_ api: API) -> Single<Response>{
        return provider.rx.request(api)
    }
}
