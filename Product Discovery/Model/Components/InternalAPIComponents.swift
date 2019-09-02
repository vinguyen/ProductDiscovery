//
//  InternalAPIComponents.swift
//  Product Discovery
//
//  Created by vi nguyen on 8/31/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]
typealias JSONArray = [Any]

enum InternalAPIRoute {
    case productsList
    case productDetail
    
    var baseURL: String {
        return Bundle.main.baseURL
    }
    
    var path: String {
        switch self {
        case .productsList: return baseURL + "/api/search"
        case .productDetail: return baseURL + "/api/products"
        }
    }
    
    var url: URL? {
        return URL(string: path)
    }
}

enum InternalAPIError: Error,  LocalizedError {
    case general
    case failedResponseParsing
    case failedToConductURLRequest
    case failedToFetchProductsList
    
    var errorDescription: String? {
        switch self {
        case .general:
            return "Something went wrong, please try again later!"
        case .failedResponseParsing:
            return "Oops! Dev's mistake make parsing data failed."
        case .failedToConductURLRequest:
            return "Could not conduct an URL request."
        case .failedToFetchProductsList:
            return "Error to fetch products list, please try again later!"
        }
    }
}

struct InternalAPIContants {
    static let successCode = "SUCCESS"
    static let contentType = "Content-Type"
    static let requestTimeout = 60.0
}

struct InternalAPIResponse  {
    var code: String
    var result: Any
    var extra: Any?
    
    init?(with json: JSONDictionary) {
        guard let code = json["code"] as? String,
            let result = json["result"] else { return nil }
        self.code = code
        self.result = result
        self.extra = json["extra"]
    }
}
