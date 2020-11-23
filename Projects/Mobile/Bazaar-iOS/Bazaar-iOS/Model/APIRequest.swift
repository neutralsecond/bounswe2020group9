//
//  APIRequest.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 23.11.2020.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestBuilder {
    
    case authenticate(appKey: String, appSecret: String)

    // MARK: - Path
    internal var path: String {
        switch self {
        case .authenticate:
            return "authenticate"
        }
    }

    // MARK: - Parameters
    internal var parameters: Parameters? {
        var params = Parameters.init()
        switch self {
        case .authenticate(let appKey, let appSecret):
            params["appkey"] = appKey
            params["appsecret"] = appSecret
        }
        return params
    }
    // MARK: - Headers
    internal var headers: HTTPHeaders? {
        var headers = HTTPHeaders.init()
        switch self {
        case .authenticate( _, _):
            headers["Accept"] = "application/json"
        }
        return headers
    }
    
    // MARK: - Methods
    internal var method: HTTPMethod {
        switch self {
        case .authenticate:
            return .post
        }
    }
}
