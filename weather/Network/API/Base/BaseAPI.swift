//
//  BaseAPI.swift
//  weather
//
//  Created by 이재문 on 2022/11/18.
//

import Moya

protocol BaseAPI: TargetType {}

extension BaseAPI {
    var baseURL: URL { URL(string: NetworkConstants.Url.api)! }

    var method: Moya.Method { .get }

    var task: Task { .requestPlain }

    var headers: [String: String]? { nil }
}
